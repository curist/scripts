(defn exec [cmd]
  (with [f (file/popen cmd)]
    (:read f :all)))

(defn ->number [s]
  (scan-number (string/trim s)))

(defmacro time [form & args]
  (def times (if (empty? args) 1 (args 0)))
  ~(do
     (def start (os/clock))
     (loop [_ :range (0 ,times)] ,form)
     (def end (os/clock))
     (def total (- end start))
     (printf "all:\t%f\navg:\t%f\ntimes:\t%f\n"
             total
             (/ total ,times)
             ,times)
     nil))
