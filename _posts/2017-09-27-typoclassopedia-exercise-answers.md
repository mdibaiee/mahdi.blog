---
layout: post
title:  "Typoclassopedia: Exercise solutions"
date:   2017-09-27 12:12:12
permalink: typoclassopedia-exercise-solutions/
categories: programming
---

I wanted to get proficient in Haskell so I decided to follow [An [Essential] Haskell Reading List][http://www.stephendiehl.com/posts/essential_haskell.html], there I stumbled upon Typoclassopedia, while the material is great, I couldn't find solutions for the exercises to check against, so I decided I would write my own and hopefully the solutions would get fixed in case I have gone wrong by others. So if you think a solution is wrong, let me know in the comments!

In each section below, I left some reference material for the exercises and then the solutions.

Functor
==========
### Instances

{% highlight haskell %}
instance Functor [] where
  fmap :: (a -> b) -> [a] -> [b]
  fmap _ []     = []
  fmap g (x:xs) = g x : fmap g xs
  -- or we could just say fmap = map
 
instance Functor Maybe where
  fmap :: (a -> b) -> Maybe a -> Maybe b
  fmap _ Nothing  = Nothing
  fmap g (Just a) = Just (g a)
{% endhighlight %}

> ((,) e) represents a container which holds an “annotation” of type e along with the actual value it holds. It might be clearer to write it as (e,), by analogy with an operator section like (1+), but that syntax is not allowed in types (although it is allowed in expressions with the TupleSections extension enabled). However, you can certainly think of it as (e,). 

> ((->) e) (which can be thought of as (e ->); see above), the type of functions which take a value of type e as a parameter, is a Functor. As a container, (e -> a) represents a (possibly infinite) set of values of a, indexed by values of e. Alternatively, and more usefully, ((->) e) can be thought of as a context in which a value of type e is available to be consulted in a read-only fashion. This is also why ((->) e) is sometimes referred to as the reader monad; more on this later. 

#### Exercises

1. Implement `Functor` instances for `Either e` and `((->) e)`.

**Solution**:
{% highlight haskell %}
instance Functor (Either e) where
  fmap _ (Left e) = Left e
  fmap g (Right a) = Right (g a)
  
instance Functor ((->) e) where
  fmap g f = g . f
{% endhighlight %}

2. Implement `Functor` instances for `((,) e)` and for `Pair`, defined as `data Pair a = Pair a a`. Explain their similarities and differences.

**Solution**:
{% highlight haskell %}
instance Functor ((,) e) where
  fmap g (a, b) = (a, g b) 
  
  
data Pair a = Pair a a
instance Functor Pair where
  fmap g (Pair a b) = Pair (g a) (g b)
{% endhighlight %}

Their similarity is in the fact that they both represent types of two values.
Their difference is that `((,) e)` (tuples of two) can have values of different types (kind of `(,)` is `* -> *`) while both values of `Pair` have the same type `a`, so `Pair` has kind `*`.

3. Implement a `Functor` instance for the type `ITree`, defined as

{% highlight haskell %}
data ITree a = Leaf (Int -> a)
             | Node [ITree a]
{% endhighlight %}

**Solution**:
{% highlight haskell %}
instance Functor ITree where
  fmap g (Leaf f) = Leaf (g . f)
  fmap g (Node xs) = Node (fmap (fmap g) xs)
{% endhighlight %}

To test this instance, I defined a function to apply the tree to an `Int`:

{% highlight haskell %}
applyTree :: ITree a -> Int -> [a]
applyTree (Leaf g) i = [g i]
applyTree (Node []) _ = []
applyTree (Node (x:xs)) i = applyTree x i ++ applyTree (Node xs) i
{% endhighlight %}

This is not a standard tree traversing algorithm, I just wanted it to be simple for testing.

Now test the instance:

{% highlight haskell %}
λ: let t = Node [Node [Leaf (+5), Leaf (+1)], Leaf (*2)]
λ: applyTree t 1
[6,2,2]
λ: applyTree (fmap id t) 1
[6,2,2]
λ: applyTree (fmap (+10) t) 1
[16, 12, 12]
{% endhighlight %}

4. Give an example of a type of kind `* -> *` which cannot be made an instance of `Functor` (without using `undefined`).

I don't know the answer to this one yet!

6. Is this statement true or false?
 
> The composition of two `Functor`s is also a `Functor`.

If false, give a counterexample; if true, prove it by exhibiting some appropriate Haskell code.

**Solution**:

It's true, and can be proved by the following function:

{% highlight haskell %}
ffmap :: (Functor f, Functor j) => (a -> b) -> f (j a) -> f (j b)
ffmap g = fmap (fmap g)
{% endhighlight %}

You can test this on arbitrary compositions of `Functor`s:

{% highlight haskell %}
main = do
  let result :: Maybe (Either String Int) = ffmap (+ 2) (Just . Right $ 5)
  print result -- (Just (Right 7))
{% endhighlight %}

### Functor Laws

{% highlight haskell %}
fmap id = id
fmap (g . h) = (fmap g) . (fmap h)
{% endhighlight %}

#### Exercises

1. Although it is not possible for a Functor instance to satisfy the first Functor law but not the second (excluding undefined), the reverse is possible. Give an example of a (bogus) Functor instance which satisfies the second law but not the first. 

**Solution**:

This is easy, consider this instance:

{% highlight haskell %}
instance Functor [] where
  fmap _ [] = [1]
  fmap g (x:xs) = g x: fmap g xs
{% endhighlight %}

Then, you can test the first and second laws:

{% highlight haskell %}
λ: fmap id [] -- [1], breaks the first law
λ: fmap ((+1) . (+2)) [1,2] -- [4, 5], second law holds
λ: fmap (+1) . fmap (+2) $ [1,2] -- [4, 5]
{% endhighlight %}

1. Which laws are violated by the evil Functor instance for list shown above: both laws, or the first law alone? Give specific counterexamples. 

{% highlight haskell %}
-- Evil Functor instance
instance Functor [] where
  fmap :: (a -> b) -> [a] -> [b]
  fmap _ [] = []
  fmap g (x:xs) = g x : g x : fmap g xs
{% endhighlight %}

**Solution**:

The instance defined breaks the first law (`fmap id [1] -- [1,1]`), but holds for the second law.
