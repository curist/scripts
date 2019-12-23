#!/usr/bin/env janet

(import ./misc/misc :prefix "")

(def [MIN-WS MAX-WS] [1 9])

(defn mv-ws-cmd [ws1 ws2]
  (string
    "i3-msg '"
    "rename workspace " ws1 " to temporary; "
    "rename workspace " ws2 " to " ws1 "; "
    "rename workspace temporary to " ws2 "'"))

(defn swap-workspace [ws1 ws2]
  (when (or (= ws1 ws2)
            (> ws1 MAX-WS) (> ws2 MAX-WS)
            (< ws1 MIN-WS) (< ws2 MIN-WS))
    (break))
  (def cmd (mv-ws-cmd ws1 ws2))
  (exec cmd))

(defn current-workspace []
  (def cmd (string
             "i3-msg -t get_workspaces | "
             "jq -r '.[] | "
             "select(.focused==true).name'"))
  (-> cmd exec ->number))

(defn main [_ &opt dir]
  (default dir "left")
  (def ws1 (current-workspace))
  (def ws2 ((if (= "left" dir) dec inc) ws1))
  (swap-workspace ws1 ws2))

