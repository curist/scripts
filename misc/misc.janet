(defn exec [cmd]
  (let [f (file/popen cmd)
        result (file/read f :all)]
    (file/close f)
    result))

(defn ->number [s]
  (scan-number (string/trim s)))
