(require '[clojure.string :as str])
(def crabs (sort < (map #(Integer/parseInt %) (str/split (slurp "input.txt") #","))))

(defn calc-fuel1 [crabs, pos] (reduce + (map #(Math/abs (- % pos)) crabs)))

(defn sum-first-n [n] (/ (* n (inc n)) 2))
(defn calc-fuel2 [crabs, pos] (reduce + (map #(sum-first-n (Math/abs (- % pos))) crabs)))

(def median 
    (if (even? (.count crabs))
        (/ (+ (.get crabs (/ (.count crabs) 2)) (.get crabs (dec (/ (.count crabs) 2)))) 2)
        (.get crabs (/ (.count crabs) 2))
    )
)
(println (str "Part 1: " (calc-fuel1 crabs median)))
(def mean (Math/floor (/ (apply + crabs) (.count crabs))))
(println (str "Part 2: " (min (calc-fuel2 crabs mean) (calc-fuel2 crabs (inc mean)))))