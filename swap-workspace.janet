#!/usr/bin/env janet

(import ./misc/misc :prefix "")

(def args (array/slice (dyn :args) 1))

(def MIN-WS 1)
(def MAX-WS 9)

(defn mv-ws-cmd [ws1 ws2]
  (let [ws1s (string ws1)
        ws2s (string ws2)]
    (string
      "i3-msg '"
      "rename workspace " ws1s " to temporary; "
      "rename workspace " ws2s " to " ws1s "; "
      "rename workspace temporary to " ws2s "'")))

(defn swap-workspace [ws1 ws2]
  (when (not (or (= ws1 ws2)
                 (> ws1 MAX-WS) (> ws2 MAX-WS)
                 (< ws1 MIN-WS) (< ws2 MIN-WS)))
    (let [cmd (mv-ws-cmd ws1 ws2)]
      (exec cmd))))

(defn current-workspace []
  (let [cmd (string
              "i3-msg -t get_workspaces | "
              "jq -r '.[] | "
              "select(.focused==true).name'")]
    (-> cmd exec ->number)))

(defn main []
  (let [dir (or (first args) "left")
        ws1 (current-workspace)
        ws2 ((if (= "left" dir) - +) ws1 1)]
    (swap-workspace ws1 ws2)))

(main)

