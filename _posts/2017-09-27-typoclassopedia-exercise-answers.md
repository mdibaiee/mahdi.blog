---
layout: post
title:  "Typoclassopedia: Exercise solutions"
date:   2017-09-27 
permalink: typoclassopedia-exercise-solutions/
categories: programming
math: true
toc: true
---

I wanted to get proficient in Haskell so I decided to follow [An [Essential] Haskell Reading List](http://www.stephendiehl.com/posts/essential_haskell.html). There I stumbled upon [Typoclassopedia](https://wiki.haskell.org/Typeclassopedia), while the material is great, I couldn't find solutions for the exercises to check against, so I decided I would write my own and hopefully the solutions would get fixed in case I have gone wrong by others. So if you think a solution is wrong, let me know in the comments!

In each section below, I left some reference material for the exercises and then the solutions.

Note: The post will be updated as I progress in Typoclassopedia myself

Functor
==========
## Instances

```haskell
instance Functor [] where
  fmap :: (a -> b) -> [a] -> [b]
  fmap _ []     = []
  fmap g (x:xs) = g x : fmap g xs
  -- or we could just say fmap = map
 
instance Functor Maybe where
  fmap :: (a -> b) -> Maybe a -> Maybe b
  fmap _ Nothing  = Nothing
  fmap g (Just a) = Just (g a)
```

> ((,) e) represents a container which holds an “annotation” of type e along with the actual value it holds. It might be clearer to write it as (e,), by analogy with an operator section like (1+), but that syntax is not allowed in types (although it is allowed in expressions with the TupleSections extension enabled). However, you can certainly think of it as (e,). 

> ((->) e) (which can be thought of as (e ->); see above), the type of functions which take a value of type e as a parameter, is a Functor. As a container, (e -> a) represents a (possibly infinite) set of values of a, indexed by values of e. Alternatively, and more usefully, ((->) e) can be thought of as a context in which a value of type e is available to be consulted in a read-only fashion. This is also why ((->) e) is sometimes referred to as the reader monad; more on this later. 

### Exercises

 1. Implement `Functor` instances for `Either e` and `((->) e)`.

    **Solution**:
    ```haskell
    instance Functor (Either e) where
      fmap _ (Left e) = Left e
      fmap g (Right a) = Right (g a)
      
    instance Functor ((->) e) where
      fmap g f = g . f
    ```

 2. Implement `Functor` instances for `((,) e)` and for `Pair`, defined as below. Explain their similarities and differences.

    **Solution**:
    ```haskell
    instance Functor ((,) e) where
      fmap g (a, b) = (a, g b) 
      
      
    data Pair a = Pair a a
    instance Functor Pair where
      fmap g (Pair a b) = Pair (g a) (g b)
    ```

    Their similarity is in the fact that they both represent types of two values.
    Their difference is that `((,) e)` (tuples of two) can have values of different types (kind of `(,)` is `* -> *`) while both values of `Pair` have the same type `a`, so `Pair` has kind `*`.

3. Implement a `Functor` instance for the type `ITree`, defined as

    ```haskell
    data ITree a = Leaf (Int -> a)
                | Node [ITree a]
    ```

    **Solution**:
    ```haskell
    instance Functor ITree where
      fmap g (Leaf f) = Leaf (g . f)
      fmap g (Node xs) = Node (fmap (fmap g) xs)
    ```

    To test this instance, I defined a function to apply the tree to an `Int`:

    ```haskell
    applyTree :: ITree a -> Int -> [a]
    applyTree (Leaf g) i = [g i]
    applyTree (Node []) _ = []
    applyTree (Node (x:xs)) i = applyTree x i ++ applyTree (Node xs) i
    ```

    This is not a standard tree traversing algorithm, I just wanted it to be simple for testing.

    Now test the instance:

    ```haskell
    λ: let t = Node [Node [Leaf (+5), Leaf (+1)], Leaf (*2)]
    λ: applyTree t 1
    [6,2,2]
    λ: applyTree (fmap id t) 1
    [6,2,2]
    λ: applyTree (fmap (+10) t) 1
    [16, 12, 12]
    ```

4. Give an example of a type of kind `* -> *` which cannot be made an instance of `Functor` (without using `undefined`).

    I don't know the answer to this one yet!

6. Is this statement true or false?
 
    > The composition of two `Functor`s is also a `Functor`.

    If false, give a counterexample; if true, prove it by exhibiting some appropriate Haskell code.

    **Solution**:

    It's true, and can be proved by the following function:

    ```haskell
    ffmap :: (Functor f, Functor j) => (a -> b) -> f (j a) -> f (j b)
    ffmap g = fmap (fmap g)
    ```

    You can test this on arbitrary compositions of `Functor`s:

    ```haskell
    main = do
      let result :: Maybe (Either String Int) = ffmap (+ 2) (Just . Right $ 5)
      print result -- (Just (Right 7))
    ```

## Functor Laws

```haskell
fmap id = id
fmap (g . h) = (fmap g) . (fmap h)
```

### Exercises

1. Although it is not possible for a Functor instance to satisfy the first Functor law but not the second (excluding undefined), the reverse is possible. Give an example of a (bogus) Functor instance which satisfies the second law but not the first. 

    **Solution**:

    This is easy, consider this instance:

    ```haskell
    instance Functor [] where
      fmap _ [] = [1]
      fmap g (x:xs) = g x: fmap g xs
    ```

    Then, you can test the first and second laws:

    ```haskell
    λ: fmap id [] -- [1], breaks the first law
    λ: fmap ((+1) . (+2)) [1,2] -- [4, 5], second law holds
    λ: fmap (+1) . fmap (+2) $ [1,2] -- [4, 5]
    ```

2. Which laws are violated by the evil Functor instance for list shown above: both laws, or the first law alone? Give specific counterexamples. 

    ```haskell
    -- Evil Functor instance
    instance Functor [] where
      fmap :: (a -> b) -> [a] -> [b]
      fmap _ [] = []
      fmap g (x:xs) = g x : g x : fmap g xs
    ```

    **Solution**:

    The instance defined breaks the first law (`fmap id [1] -- [1,1]`), but holds for the second law.
    
Category Theory
===============

The Functor section links to [Category Theory](https://en.wikibooks.org/wiki/Haskell/Category_theory), so here I'm going to cover the exercises of that page, too.

## Introduction to categories

### Category laws:

1. The compositions of morphisms need to be **associative**:
   
    $f \circ (g \circ h) = (f \circ g) \circ h$
  
2. The category needs to be **closed** under the composition operator. So if $f : B \to C$ and $g: A \to B$, then there must be some $h: A \to C$ in the category such that $h = f \circ g$.
3. Every object $A$ in a category must have an identity morphism, $id_A : A \to A$ that is an identity of composition with other morphisms. So for every morphism $g: A \to B$:
    $g \circ id_A = id_B \circ g = g$.
    
### Exercises

1. As was mentioned, any partial order $(P, \leq)$ is a category with objects as the elements of P and a morphism between elements a and b iff $a \leq b$. Which of the above laws guarantees the transitivity of $\leq$?

    **Solution**:
    
    The second law, which states that the category needs to be closed under the composition operator guarantess that because we have a morphism $a \leq b$, and another morphism $b \leq c$, there must also be some other morphism such that $a \leq c$.
    
2. If we add another morphism to the above example, as illustrated below, it fails to be a category. Why? Hint: think about associativity of the composition operation.
   
   ![not a category, an additional h: B -> A](/img/typoclassopedia/not-a-cat.png)

    **Solution**:
    
    The first law does not hold:
    
    $f \circ (g \circ h) = (f \circ g) \circ h$
    
    To see that, we can evaluate each side to get an inequality:
    
    $g \circ h = id_B$
    
    $f \circ g = id_A$
    
    $f \circ (g \circ h) = f \circ id_B = f$
    
    $(f \circ g) \circ h = id_A \circ h = h$
    
    $f \neq h$
    
## Functors

### Functor laws:

1. Given an identity morphism $id_A$ on an object $A$, $F(id_A)$ must be the identity morphism on $F(A)$, so:
    $F(id_A) = id_{F(A)}$
    
2. Functors must distribute over morphism composition:
    $F(f \circ g) = F(f) \circ F(g)$
    
### Exercises

1. Check the functor laws for the diagram below.

    ![functor diagram](/img/typoclassopedia/functor-diagram.png)

    **Solution**:

    The first law is obvious as it's directly written, the pale blue dotted arrows from $id_C$ to $F(id_C) = id_{F(C)}$ and $id_A$ and $id_B$ to $F(id_A) = F(id_B) = id_{F(A)} = id_{F(B)}$ show this.

    The second law also holds, the only compositions in category $C$ are between $f$ and identities, and $g$ and identities, there is no composition between $f$ and $g$.

    (Note: The second law always hold as long as the first one does, as was seen in Typoclassopedia)
    
2. Check the laws for the Maybe and List functors.
    
    **Solution**:
    
    ```haskell
    instance Functor [] where
      fmap :: (a -> b) -> [a] -> [b]
      fmap _ []     = []
      fmap g (x:xs) = g x : fmap g xs
    
    -- check the first law for each part:
    fmap id [] = []
    fmap id (x:xs) = id x : fmap id xs = x : fmap id xs -- the first law holds recursively
    
    -- check the second law for each part:
    fmap (f . g) [] = []
    fmap (f . g) (x:xs) = (f . g) x : fmap (f . g) xs = f (g x) : fmap (f . g) xs
    fmap f (fmap g (x:xs)) = fmap f (g x : fmap g xs) = f (g x) : fmap (f . g) xs
    ```

    ```haskell
    instance Functor Maybe where
      fmap :: (a -> b) -> Maybe a -> Maybe b
      fmap _ Nothing  = Nothing
      fmap g (Just a) = Just (g a)
    
    -- check the first law for each part:
    fmap id Nothing = Nothing
    fmap id (Just a) = Just (id a) = Just a
    
    -- check the second law for each part:
    fmap (f . g) Nothing = Nothing
    fmap (f . g) (Just x) = Just ((f . g) x) = Just (f (g x))
    fmap f (fmap g (Just x)) = Just (f (g x)) = Just ((f . g) x)
    ```
    
Applicative
===========

## Laws

1. The identity law:
   
    ```haskell
    pure id <*> v = v
    ```

2. Homomorphism:

    ```haskell
    pure f <*> pure x = pure (f x)
    ```

    Intuitively, applying a non-effectful function to a non-effectful argument in an effectful context is the same as just applying the function to the argument and then injecting the result into the context with pure.
    
3. Interchange:

    ```haskell
    u <*> pure y = pure ($ y) <*> u
    ```

    Intuitively, this says that when evaluating the application of an effectful function to a pure argument, the order in which we evaluate the function and its argument doesn't matter.
    
4. Composition:

    ```haskell
    u <*> (v <*> w) = pure (.) <*> u <*> v <*> w
    ```

    This one is the trickiest law to gain intuition for. In some sense it is expressing a sort of associativity property of (`<*>`). The reader may wish to simply convince themselves that this law is type-correct. 
    
### Exercises

(Tricky) One might imagine a variant of the interchange law that says something about applying a pure function to an effectful argument. Using the above laws, prove that

```haskell
pure f <*> x = pure (flip ($)) <*> x <*> pure f
```

**Solution**:

```haskell
pure (flip ($)) <*> x <*> pure f
  = (pure (flip ($)) <*> x) <*> pure f -- <*> is left-associative
  = pure ($ f) <*> (pure (flip ($)) <*> x) -- interchange
  = pure (.) <*> pure ($ f) <*> pure (flip ($)) <*> x -- composition
  = pure (($ f) . (flip ($))) <*> x -- homomorphism
  = pure ((flip ($) f) . (flip ($))) <*> x -- identical
  = pure f <*> x
```
Explanation of the last transformation:

`flip ($)` has type `a -> (a -> c) -> c`, intuitively, it first takes an argument of type `a`, then a function that accepts that argument, and in the end it calls the function with the first argument. So `(flip ($) 5)` takes as argument a function which gets called with `5` as it's argument. If we pass `(+ 2)` to `(flip ($) 5)`, we get `(flip ($) 5) (+2)` which is equivalent to the expression `(+2) $ 5`, evaluating to `7`.

`flip ($) f` is equivalent to `\x -> x $ f`, that means, it takes as input a function and calls it with the function `f` as argument.

The composition of these functions works like this: First `flip ($)` takes `x` as it's first argument, and returns a function `(flip ($) x)`, this function is awaiting a function as it's last argument, which will be called with `x` as it's argument. Now this function `(flip ($) x)` is passed to `flip ($) f`, or to write it's equivalent `(\x -> x $ f) (flip ($) x)`, this results in the expression `(flip ($) x) f`, which is equivalent to `f $ x`. 

You can check the type of `(flip ($) f) . (flip ($))` is something like this (depending on your function `f`):

```haskell
λ: let f = sqrt
λ: :t (flip ($) f) . (flip ($))
(flip ($) f) . (flip ($)) :: Floating c => c -> c
```

Also see [this question on Stack Overflow](https://stackoverflow.com/questions/46503793/applicative-prove-pure-f-x-pure-flip-x-pure-f/46505868#46505868) which includes alternative proofs.

## Instances

Applicative instance of lists as a collection of values:

```haskell
newtype ZipList a = ZipList { getZipList :: [a] }
 
instance Applicative ZipList where
  pure :: a -> ZipList a
  pure = undefined   -- exercise
 
  (<*>) :: ZipList (a -> b) -> ZipList a -> ZipList b
  (ZipList gs) <*> (ZipList xs) = ZipList (zipWith ($) gs xs)
```

Applicative instance of lists as a non-deterministic computation context:

```haskell
instance Applicative [] where
  pure :: a -> [a]
  pure x = [x]
 
  (<*>) :: [a -> b] -> [a] -> [b]
  gs <*> xs = [ g x | g <- gs, x <- xs ]
```

### Exercises

1. Implement an instance of `Applicative` for `Maybe`.
  
    **Solution**:
    
    ```haskell
    instance Applicative (Maybe a) where
      pure :: a -> Maybe a
      pure x = Just x
      
      (<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
      _ <*> Nothing = Nothing
      Nothing <*> _ = Nothing
      (Just f) <*> (Just x) = Just (f x)
    ```
    
2. Determine the correct definition of `pure` for the `ZipList` instance of `Applicative`—there is only one implementation that satisfies the law relating `pure` and `(<*>)`. 
    
    **Solution**:
    
    ```haskell
    newtype ZipList a = ZipList { getZipList :: [a] }
    
    instance Functor ZipList where
      fmap f (ZipList list) = ZipList { getZipList = fmap f list }
    
    instance Applicative ZipList where
      pure = ZipList . pure
    
      (ZipList gs) <*> (ZipList xs) = ZipList (zipWith ($) gs xs)
    ```

    You can check the Applicative laws for this implementation.
    
## Utility functions

### Exercises

1. Implement a function
    `sequenceAL :: Applicative f => [f a] -> f [a]`
    There is a generalized version of this, `sequenceA`, which works for any `Traversable` (see the later section on `Traversable`), but implementing this version specialized to lists is a good exercise. 
    
    **Solution**:
    
    ```haskell
    createList = replicate 1

    sequenceAL :: Applicative f => [f a] -> f [a]
    sequenceAL = foldr (\x b -> ((++) . createList <$> x) <*> b) (pure [])
    ```
    
    Explanation:
    
    First, `createList` is a simple function for creating a list of a single element, e.g. `createList 2 == [2]`.
    
    Now let's take `sequenceAL` apart, first, it does a fold over the list `[f a]`, and `b` is initialized to `pure []`, which results in `f [a]` as required by the function's output.
    
    Inside the function, `createList <$> x` applies `createList` to the value inside `f a`, resulting in `f [a]`, and then `(++)` is applied to the value again, so it becomes `f ((++) [a])`, now we can apply the function `(++) [a]` to `b` by `((++) . createList <$> x) <*> b`, which results in `f ([a] ++ b)`.

## Alternative formulation

### Definition

```haskell
class Functor f => Monoidal f where
  unit :: f ()
  (**) :: f a -> f b -> f (a,b)
```

### Laws:

1. Left identity
   
    ```haskell
    unit ** v ≅ v
    ```

2. Right identity
   
    ```haskell
    u ** unit ≅ u
    ```

3. Associativity
   
    ```haskell
    u ** (v ** w) ≅ (u ** v) ** w
    ```
    
4. Neutrality

    ```haskell
    fmap (g *** h) (u ** v) = fmap g u ** fmap h v
    ```
    
### Isomorphism

In the laws above, `≅` refers to isomorphism rather than equality. In particular we consider:

```haskell
(x,()) ≅ x ≅ ((),x)
((x,y),z) ≅ (x,(y,z))
```
    
    
### Exercises

1. Implement `pure` and `<*>` in terms of `unit` and `**`, and vice versa.
    
    ```haskell
    unit :: f ()
    unit = pure ()
    
    (**) :: f a -> f b -> f (a, b)
    a ** b = fmap (,) a <*> b
    
    pure :: a -> f a
    pure x = unit ** x
    
    (<*>) :: f (a -> b) -> f a -> f b
    f <*> a = fmap (uncurry ($)) (f ** a) = fmap (\(f, a) -> f a) (f ** a)
    ```

2. Are there any `Applicative` instances for which there are also functions `f () -> ()` and `f (a,b) -> (f a, f b)`, satisfying some "reasonable" laws? 

    The [`Arrow`](https://wiki.haskell.org/Typeclassopedia#Arrow) type class seems to satisfy these criteria.
    
    ```haskell
      first unit = ()
      
      (id *** f) (a, b) = (f a, f b)
    ```
    
3. (Tricky) Prove that given your implementations from the first exercise, the usual Applicative laws and the Monoidal laws stated above are equivalent. 

    1. Identity Law
     
        ```haskell
        pure id <*> v
          = fmap (uncurry ($)) ((unit ** id) ** v)
          = fmap (uncurry ($)) (id ** v)
          = fmap id v
          = v
        ```
    
    2. Homomorphism
      
        ```haskell
        pure f <*> pure x
          = (unit ** f) <*> (unit ** x)
          = fmap (\(f, a) -> f a) (unit ** f) (unit ** x)
          = fmap (\(f, a) -> f a) (f ** x)
          = fmap f x
          = pure (f x)
        ```
        
    3. Interchange
  
        ```haskell
        u <*> pure y
          = fmap (uncurry ($)) (u ** (unit ** y))
          = fmap (uncurry ($)) (u ** y)
          = fmap (u $) y
          = fmap ($ y) u
          = pure ($ y) <*> u
        ```
    
    4. Composition
  
        ```haskell
        u <*> (v <*> w)
          = fmap (uncurry ($)) (u ** (fmap (uncurry ($)) (v ** w)))
          = fmap (uncurry ($)) (u ** (fmap v w))
          = fmap u (fmap v w)
          = fmap (u . v) w
          = pure (.) <*> u <*> v <*> w =
        ```

Monad
=====

## Definition

```haskell
class Applicative m => Monad m where
  return :: a -> m a
  (>>=)  :: m a -> (a -> m b) -> m b
  (>>)   :: m a -> m b -> m b
  m >> n = m >>= \_ -> n
 
  fail   :: String -> m a
```

## Instances

```haskell
instance Monad Maybe where
  return :: a -> Maybe a
  return = Just
 
  (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
  (Just x) >>= g = g x
  Nothing  >>= _ = Nothing
```

### Exercises

1. Implement a `Monad` instance for the list constructor, `[]`. Follow the types!
   
   **Solution**:
   
    ```haskell
    instance Monad [] where
      return a = [a]
      
      [] >> _ = []
      (x:xs) >>= f = f x : xs >>= f
    ```
    
2. Implement a `Monad` instance for `((->) e)`.
   
   **Solution**:
   
    ```haskell
    instance Monad ((->) e) where
      return x = const x
      
      g >>= f = f . g
    ```

3. Implement `Functor` and `Monad` instance for `Free f`, defined as:

    ```haskell
    data Free f a = Var a
                  | Node (f (Free f a))
    ```
    
    You may assume that `f` has a `Functor` instance. This is known as the _free monad_ built from the functor f. 
    
    **Solution**:
    
    ```haskell
    instance Functor (Free f) where
      fmap f (Var a) = Var (f a)
      fmap f (Node x) = Node (f x)
      
    instance Monad (Free f) where
      return x = Var x
      
      (Var x) >>= f = Var (f x)
      (Node x) >>= f = Node (fmap f x)
    ```
