#!/usr/bin/env fennel

(local sh (require :sh))
(local i3msg (sh.command :i3-msg))
(local jq (sh.command :jq))

(local [MIN_WS MAX_WS] [1 9])

(fn move-workspace [ws1 ws2]
  (i3msg (.. "'"
             "rename workspace " ws1 " to temporary; "
             "rename workspace " ws2 " to " ws1 "; "
             "rename workspace temporary to " ws2 "'")))

(fn get-current-workspace []
  (-> (i3msg "-t get_workspaces")
      (jq "-r '.[] | select(.focused==true).name'")
      tostring tonumber))

(let [direction (or (. arg 1) :left)
      ws1 (get-current-workspace)
      ws2 (if (= direction :left) (- ws1 1) (+ ws1 1))]
  (when (or (= ws1 ws2)
            (> ws1 MAX_WS) (> ws2 MAX_WS)
            (< ws1 MIN_WS) (< ws2 MIN_WS))
    (lua :return))
  (move-workspace ws1 ws2))

