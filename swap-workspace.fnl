#!/usr/bin/env fennel

(def sh (require :sh))
(def i3msg (sh.command :i3-msg))
(def jq (sh.command :jq))

(defn move-workspace [ws1 ws2]
  (i3msg (.. "'"
             "rename workspace " ws1 " to temporary; "
             "rename workspace " ws2 " to " ws1 "; "
             "rename workspace temporary to " ws2 "'")))

(defn get-current-workspace []
  (-> (i3msg "-t get_workspaces")
      (jq "-r '.[] | select(.focused==true).name'")
      tostring tonumber))

(defn swap-it [direction]
  (let [[MIN_WS MAX_WS] [1 9]
        ws1 (get-current-workspace)
        ws2 (if (= direction :left) (- ws1 1) (+ ws1 1))
        oob (or (= ws1 ws2)
                (> ws1 MAX_WS) (> ws2 MAX_WS)
                (< ws1 MIN_WS) (< ws2 MIN_WS))]
    (when (not oob)
      (move-workspace ws1 ws2))))

(let [direction (or (. arg 1) :left)]
  (swap-it direction))
