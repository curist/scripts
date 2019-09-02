(defn exec [cmd]
  (with [f (file/popen cmd)]
    (:read f :all)))

(defn ->number [s]
  (scan-number (string/trim s)))

(defn min-max
  "ensure a number n to in range of lower and upper."
  [n lower upper]
  (-> n (max lower) (min upper)))

(defmacro time [form & args]
  (def times (if (empty? args) 1 (args 0)))
  ~(do
     (def start (os/clock))
     (loop [_ :range (0 ,times)] ,form)
     (def end (os/clock))
     (def total (- end start))
     (print "all:\t" total "\n"
            "avg:\t" (/ total ,times) "\n"
            "times:\t" ,times)
     nil))
