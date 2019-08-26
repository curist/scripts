(defn import-all []
  (def modules
    (->> (os/dir (dyn :syspath))
         (filter |(string/has-suffix? "janet" $))
         (map |((string/split "." $) 0))))
  (each m modules (import* m)))
