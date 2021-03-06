-- Selected solutions
-- Only did the questions I don't remember very well from the workshops

import Data.Char

-- Some declarations
data Tree k v = Leaf | Node k v (Tree k v) (Tree k v)
    deriving (Show, Eq, Ord)

data Expression
    = Var Variable
    | Num Integer
    | Plus Expression Expression
    | Minus Expression Expression
    | Times Expression Expression
    | Div Expression Expression

data Variable = A | B

data BST a = Empty | Elem (BST a) a (BST a)
    deriving (Show, Eq, Ord)

-- Workshop 1
xor :: Bool -> Bool -> Bool
xor x y = x /= y

append :: [a] -> [a] -> [a]
append xs [] = xs
append [] ys = ys
append (x:xs) ys = x : append xs ys

myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

getNthElem :: Int -> [a] -> a
getNthElem _ [] = error "Empty list"
getNthElem 1 xs = head xs
getNthElem n xs
    | n < 1 = error "n is less than 1"
    | otherwise = getNthElem(n-1) (tail xs)

-- Workshop 2
factorial :: Int -> Int
factorial 0 = 1
factorial 1 = 1
factorial n = factorial(n-1) * n

myElem :: (Eq a) => a -> [a] -> Bool
myElem _ [] = False
myElem y (x:xs)
    | y == x = True
    | otherwise = myElem y xs

longestPrefix :: (Eq a) => [a] -> [a] -> [a]
longestPrefix [] [] = []
longestPrefix xs [] = []
longestPrefix [] ys = []
longestPrefix (x:xs) (y:ys)
    | x == y = x : longestPrefix xs ys
    | otherwise = longestPrefix xs ys

minmax :: Int -> Int -> [Int]
minmax min max = [min .. max]

-- Workshop 3
same_shape :: Tree a b -> Tree c d -> Bool
same_shape Leaf Leaf = True
same_shape Leaf _ = False
same_shape _ Leaf = False
same_shape (Node _ _ l1 r1) (Node _ _ l2 r2) = 
            same_shape l1 l2 && same_shape r1 r2

eval :: Integer -> Integer -> Expression -> Integer
eval a b (Var A) = a
eval a b (Var B) = b
eval a b (Num n) = n
eval a b (Plus e1 e2)  = (eval a b e1) + (eval a b e2)
eval a b (Minus e1 e2) = (eval a b e1) - (eval a b e2)
eval a b (Times e1 e2) = (eval a b e1) * (eval a b e2)
eval a b (Div e1 e2)   = (eval a b e1) `div` (eval a b e2)

-- Workshop 4
transpose :: [[a]] -> [[a]]
transpose ([]:_) = []
transpose xs = map head xs : transpose (map tail xs)

triples1 :: [Int] -> (Int, Int, Int)
triples1 xs = (length xs, sum xs, sum(map(^2) xs))

triples2 :: [Int] -> (Int, Int, Int)
triples2 xs = go xs (0, 0, 0)
    where go [] acc = acc
          go (x:xs) (l, s, ss) = go xs (l + 1,  s + x, ss + x^2)

-- Workshop 5
maybeApply :: (a -> b) -> Maybe a -> Maybe b
maybeApply _ Nothing = Nothing
maybeApply f (Just x) = Just (f x)

zWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zWith _ [] [] = []
zWith _ xs [] = []
zWith _ [] ys = []
zWith f (x:xs) (y:ys) = f x y : zWith f xs ys

-- Workshop 10
maybe_tail :: [a] -> Maybe [a]
maybe_tail [] = error "tail of empty list"
maybe_tail (_:xs) = Just xs

maybe_drop :: Int -> [a] -> Maybe [a]
maybe_drop 0 xs = Just xs
maybe_drop n xs | n > 0 = 
    let mt = maybe_tail xs in 
    case mt of
            Nothing -> Nothing
            Just xs1 -> maybe_drop (n-1) xs1


maybe_drop' :: Int -> [a] -> Maybe [a]
maybe_drop' 0 xs = Just xs
maybe_drop' n xs | n > 0 = 
    maybe_tail xs >>= maybe_drop' (n-1)

-- data Tree a = Empty | Node (Tree a) a (Tree a)
print_tree :: (Show a) => BST a -> IO()
print_tree Empty = return()
print_tree (Elem l x r) = do
        print_tree l
        print x
        print_tree r

is_string_digits :: String -> Bool
is_string_digits [] = False
is_string_digits xs = (length (filter isDigit xs) == length xs)

str_to_int_list :: String -> [Int]
str_to_int_list [] = []
str_to_int_list xs
    | is_string_digits xs = [digitToInt(x) | x <- xs]
    | otherwise = []

str_to_num :: String -> Maybe Int
str_to_num xs
    | intlist /= [] = Just (go intlist 0)
    | otherwise = Nothing
    where intlist = str_to_int_list xs
          go [] acc = acc
          go (x:xs) acc = go xs ((acc * 10) + x)


          
read_lines_sum :: IO Int
read_lines_sum = do
    line <- getLine
    let num = str_to_num line
    case num of
        Nothing -> return 0
        Just num -> do
                sum <- read_lines_sum
                return (num + sum)


read_lines_sum' :: IO Int
read_lines_sum' = 
        getLine >>= 
        \line -> case str_to_num line of
            Nothing -> return 0
            Just num -> 
                read_lines_sum' >>=
                \sum -> return (num + sum)

sum_lines_list :: IO Int
sum_lines_list = do
    nums <- list_num_lines
    return (sum nums)

list_num_lines :: IO [Int]
list_num_lines = do
    line <- getLine
    let num = str_to_num line
    case num of
        Nothing -> return []
        Just num -> do
            nums <- list_num_lines
            return (num:nums)

-- Workshop 11

fib :: Int -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib(n-1) + fib(n-2)

allfibs :: [Integer]
allfibs = [x | x <- zipWith (+) fibs (tail fibs)]
    where fibs = map fib [0..]

-- Extra

mysum :: [Int] -> Int
mysum xs = foldr (+) 0 xs

myproduct :: [Int] -> Int
myproduct xs = foldr (*) 1 xs

fold_map :: (a -> b) -> [a] -> [b]
fold_map _ [] = []
fold_map f xs = foldr (\y ys -> f y:ys) [] xs

fold_filter :: (a -> Bool) -> [a] -> [a]
fold_filter _ [] = []
fold_filter f xs = foldr (\y ys -> if f y then y:ys else ys) [] xs

--data BST a = Empty | Elem (BST a) a (BST a)
--deriving (Show, Eq, Ord)
map_BST :: (a -> a) -> BST a -> BST a
map_BST _ Empty = Empty
map_BST f (Elem Empty x Empty) = (Elem Empty (f x) Empty)
map_BST f (Elem l x r) = Elem (map_BST f l) (f x) (map_BST f r)

sumTuples list = foldl (\(xAcc, yAcc) (x, y) -> (xAcc + x, yAcc + y)) (0,0) list

merge_three :: [Int] -> [Int] -> [Int] -> [Int]
merge_three xs ys zs = concat [[a,b,c] | (a,b,c) <- zip3 xs ys zs]

subList :: (Eq a) => [a] -> [a] -> Bool
subList [] [] = True
subList xs ys = any (==xs) subys
    where subys = (split_lists (length xs) ys)

subList' :: (Eq a) => [a] -> [a] -> Bool
subList' [] [] = True
subList' xs ys = check_lists xs subys
    where subys = (split_lists (length xs) ys)

check_lists :: (Eq a) => [a] -> [[a]] -> Bool
check_lists _ [] = False
check_lists xs (y:ys)
    | xs == y = True
    | otherwise = check_lists xs ys

split_lists :: Int -> [a] -> [[a]]
split_lists _ [] = []
split_lists n xs
    | length first == n = first : restxs
    | otherwise = restxs
    where (first, rest) = splitAt n xs
          restxs = split_lists n (tail first ++ rest)

split_lists' :: Int -> [a] -> [[a]]
split_lists' _ [] = []
split_lists' n xs = filter (\x -> length x == n) list
    where list = take n xs : split_lists' n (drop 1 xs)

combine:: [String] -> [String] -> [String]
combine xs ys = [x ++ y | (x, y) <- zip xs ys]

combine' :: [String] -> [String] -> [String]
combine' xs ys = zipWith (++) xs ys

subtotal :: (Num a) => [a] -> [a]
subtotal [] = []
subtotal [x] = [x]
subtotal xs = go xs 0
    where go [] acc = []
          go (x:xs) acc = (acc+x) : go xs (acc+x)
