;; vi: ft=scheme

(import :gerbil/gambit)
(import :std/text/json)

;; ws number should in range of 1 ~ 8
(def min-ws 1)
(def max-ws 8)

(def (mv-ws-cmd ws1s ws2s)
  (let ((ws1 (number->string ws1s))
        (ws2 (number->string ws2s)))
    (string-append
      "i3-msg '"
      "rename workspace " ws1 " to temporary; "
      "rename workspace " ws2 " to " ws1 "; "
      "rename workspace temporary to " ws2 "'")))

(def (swap-workspace ws1 ws2)
  (if (or (= ws1 ws2)
          (> ws1 max-ws) (> ws2 max-ws)
          (< ws1 min-ws) (< ws2 min-ws))
      'nop
      (let ((cmd (mv-ws-cmd ws1 ws2)))
        (shell-command cmd))))

(def current-workspace
  (let* ((cmd "i3-msg -t get_workspaces")
         (res (cdr (shell-command cmd #t)))
         (json (string->json-object res))
         (focused-ws (car
                       (filter
                         (lambda (t) (hash-ref t 'focused))
                         json)))
         (ws (hash-ref focused-ws 'num)))
    ws))


(def (main . arg)
  (let* ((dir (if (pair? arg)
                  (car arg)
                  "left"))
         (ws1 current-workspace)
         (ws2 ((if (equal? "left" dir) 1- 1+) ws1)))
    (swap-workspace ws1 ws2)))


(export main)
;; gxc -exe -static swap-workspace.ss
