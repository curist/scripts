#!/usr/bin/env bb

(use 'clojure.string)
(require '[babashka.process :refer [process check]])

(def MIN_WS 1)
(def MAX_WS 9)

(defn move-workspace [ws1 ws2]
  (let [cmd (str "rename workspace " ws1 " to temporary;"
                 "rename workspace " ws2 " to " ws1 ";"
                 "rename workspace temporary to " ws2)]
    (-> (process ["i3-msg" cmd]) :out slurp)))

(defn get-current-workspace []
  (-> (process '[i3-msg -t get_workspaces])
      (process '[jq -r ".[] | select(.focused==true).name"])
      :out slurp trim Integer/parseInt))

(let [[arg-direction] *command-line-args*
      direction (or arg-direction "left")
      ws1 (get-current-workspace)
      ws2 (if (= direction "left") (dec ws1) (inc ws1))]
  (when-not (or (= ws1 ws2)
                (> ws1 MAX_WS) (> ws2 MAX_WS)
                (< ws1 MIN_WS) (< ws2 MIN_WS))
    (move-workspace ws1 ws2)))

