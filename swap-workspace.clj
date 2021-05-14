#!/usr/bin/env bb

(ns swap-workspace
  (:require [clojure.string :refer [trim]]
            [babashka.process :refer [process]]))

(defn move-workspace [ws1 ws2]
  (let [cmd (str "rename workspace " ws1 " to temporary;"
                 "rename workspace " ws2 " to " ws1 ";"
                 "rename workspace temporary to " ws2)]
    (-> (process ["i3-msg" cmd]) :out slurp)))

(defn get-current-workspace []
  (-> (process '[i3-msg -t get_workspaces])
      (process '[jq -r ".[] | select(.focused==true).name"])
      :out slurp trim Integer/parseInt))

(defn swap-it [direction]
  (let [[MIN_WS MAX_WS] [1 9]
        ws1 (get-current-workspace)
        ws2 (if (= direction "left") (dec ws1) (inc ws1))
        oob (or (= ws1 ws2)
                (> ws1 MAX_WS) (> ws2 MAX_WS)
                (< ws1 MIN_WS) (< ws2 MIN_WS))]
    (when-not oob (move-workspace ws1 ws2))))

(let [[arg-direction] *command-line-args*
      direction (or arg-direction "left")]
  (swap-it direction))

