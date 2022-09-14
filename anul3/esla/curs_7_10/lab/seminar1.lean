
/-
  # Introduction 

  Goals of this lab:
    + learning the basics of Lean and more generally those of interactive theorem proving 
    + implementing some of the logical systems you will learn in the course

  Lean is a interactive theorem prover and a functional programming language
  with a rich type systems based on *dependent type theory*.
  Beyond programming, the expressiveness of the type system will allow us to state *theorems* and prove them, 
  as we will see in future labs.

-/

/-
  # LAB 1: Basics of functional programming in Lean
-/

/-
  We can use the `#check` command to see the type of a term.
  In Lean things like numerical constants, functions, types 
  are all terms and can be used as such. 
-/

#eval 1 + 1 

#check 7
#check true
#check "hello world"
#check Nat
#check Bool
#check String 
#check Nat → String


/-
  Tip: You can hover over unicode symbols to see how to input them. 
  For example `→` is typed `\to`.
-/

/-
  ## Defining functions
  We can define functions using the following syntax.
-/
def plus5 (n : Nat) : Nat := n + 5 
def ori(a b: Nat): Nat := a * b

#check (ori 2)
#eval (ori 2) 4

/-
  Types may be omitted when Lean is able to infer them.
-/
def plus5' (n : Nat) := n + 5

def plus5'' (n) := n + 5

/-
  We can evaluate a function with `#eval`.
-/

#check plus5''
#eval plus5'' 8

#check plus5'' 8
#eval plus5 8

/-
  Lambda expressions (also known as lambda abstractions, anonymous functions, closures) are first-class objects in Lean.
  Below, `fun n : Nat => n + 5` is a term representing the function that maps `n` to `n + 5`.
  We could have also defined our `plus5` function to simply be this lambda expression.
-/
#check fun n : Nat => n + 5 
#check λ n : Nat => n + 5
-- \x -> x + 5 

def plus5''' := fun n : Nat => n + 5

/-
  Note that plus5, plus5', plus5'' and plus5''' are all the *same* definition,
  just written in different notations.
-/

/-  
  ## Currying.
  Functions with multiple arguments are usually *curried*. 
  Consider the addition on natural numbers, `Nat.add`, which should take two `Nat`s and return a `Nat`.
  Its type is `Nat → Nat → Nat`, which is the same as `Nat → (Nat → Nat)` (i.e. `→` is right associative).
  `Nat.add` takes a natural number `n` and returns a function `Nat.add n : Nat → Nat` (the function adding `n` to its argument).
  `Nat.add n` is also called a *partial application* of `Nat.add`.
  If we further apply it to an `n : Nat`, we get `(Nat.add n) m : Nat` (the sum between `n` and `m`).
  Function application is left associative, so we simply write `Nat.add n m`. 
-/

-- Nat → (Nat → Nat)
-- (ℕ, 0, succ)
-- 0 ∈ ℕ 
-- succ : ℕ → ℕ 
#check Nat.add_succ

#check Nat.add
#check Nat.add 5
#check Nat.add 5 7
#eval Nat.add 5 7

/-
  Even one more way to write `plus5`, as a partial application of `Nat.add` to `5`:
-/
def plus5'''' := Nat.add 5

/-
  Functions of several argument can be written as:
-/
def plus (n : Nat) (m : Nat) := n + m
/-
  When some arguments have the same type they can be placed under a single type signature
-/
def plus' (n m : Nat) := n + m


/-
  It is immediate in Lean to write generic functions whose arguments can be of arbitrary types. 
  The details of how this works are beyond the scope of this lab.

  **Exercise 1**: Replace the `sorry` with a definition for `applyFunction` below, which,
  for arbitrary types `α` and `β`, 
  takes some `a : α` and a function `f : α → β` and applies `f` to the argument `a`.
-/

def mul: Nat → Nat → Nat := λ a b => a * b 
#check mul
#eval mul 3 4

def applyFunction {α β: Type} (a: α) (f: α -> β): β := f a 
def applyFunction' {α β: Type}: α → (α → β) → β := λ a f => f a 
def applyFunction'' {α β: Type}: α → (α → β) → β := fun a f => f a 

#eval applyFunction 2 (fun x => x + 1)
#eval applyFunction 2 (λ x => "lolz you got this string: " ++ toString x)

#check applyFunction 
#check @applyFunction

#eval @applyFunction Nat Nat 2 (fun x => x + 1)

-- applyFunction :: a -> (a -> b) -> b 


/-
  ## Defining new types
  We've seen some builtin types, like `Nat` or `String`.
  Defining new types is one of the most important aspects of working in Lean,
  and next we will see some of ways of doing this.
-/

/-
  A *structure*, like in most programming language (called "record" in some languages),
  is a tuple made of a number of named fields of potentially different types.
-/
structure Student where 
  name : String 
  group : Nat

#check Student

/-
  **Exercise 2**:
    Define a term `me` of type `Student` as below, by filling the underscores.
    In Lean, you can always place an underscore where a term is expected, 
    and the infoview will show you its expected type if you move the carret over it.
-/
def me : Student := {name := "Bogdan", group := 300}

/-
  We can access the fields of structure using dot notations, 
  like in the following example (also called projection notation).
-/
def personToString : Student → String := 
  fun student => student.name ++ " " ++ (toString student.group)


-- deriving Show
-- deriving Repr 
#check @toString

/-
  **Exercise 3**:
  Apply the `personToString` function on the `me` you defined earlier and `#eval` the result.
-/

def meToString := personToString me
#eval meToString

/-
  Like with functions, it's easy to construct types depending on other types.
  Given two types `α` and `β`, there is a type `Prod α β` made of pairs `(a, b)` where `a : α` and `b : β`.
  This is a builtin type whose definition is roughly the one below (we put it in the `Hidden` namespace to avoid name conflicts 
  with the builtin `Prod`).
-/

namespace Hidden

  structure Prod (α β : Type) where 
    fst : α
    snd : β

/-
  Note that `Prod` has two type parameters; `Prod` is of type `Type → Type → Type`.
-/

    #check Prod

end Hidden

-- Prod Nat String
-- Nat × String 

#check (2, "str")


/-
  When we want to defer writing a definition for later, we can replace it to `sorry`,
  a "term" that fits everywhere, for Lean to stop complaining.
  Lean introduces the notations `α × β` for `Prod α β` 
  and `(a, b)` for the term in `α × β` given by `{fst := a, snd := b}`.

  **Exercise 4**:
    Fill the `sorry` below to define the function `swap` that, given the pair `(a, b) : Prod α β`, swaps its components,
    returning the pair `(b, a) : Prod β α`. 
    You may use the notations exaplained above or the notations you learned for structures.
-/

def swap {α β: Type} (p: α × β): (β × α) := (p.snd, p.fst)
def swap''' {α β: Type}: (α × β) → (β × α) := λ p => (p.snd, p.fst)
def swap' { α β : Type } (p : Prod α β) : Prod β α := {
  fst := p.snd,
  snd := p.fst
}
def swap'' { α β : Type } : α × β → β × α := 
  λ p => (p.snd, p.fst)   

/-
  ## Inductive types, pattern matching and recursion
  Inductive types (related to algebraic datatypes in other languages) 
  are defined by specifying all the ways their terms can be constructed.
  The ways a term of an inductive type can, by definition, 
  be constructed are called *constructors* and are functions whose return type has to be the inductive type being defined.
-/

namespace Hidden 

  /-
    Again in the `Hidden` namespace to avoid naming conflicts, 
    below is the definition of the `Nat` type we used earlier.
  -/

  inductive Nat where
  | zero : Nat 
  | succ : Nat → Nat

  -- zero : Nat
  -- one = succ zero : Nat
  -- two = succ (succ zero) : Nat


  /-
    The constructors are `zero` and `succ`.
    This means that terms of type `Nat` are all either `zero` or of the form `succ n` for some `n : Nat`.
  -/

end Hidden

/-
  The constructors of `Nat` are not in the global namespace; their full names are `Nat.zero` and `Nat.succ`.
  We open the `Nat` namespace to have them available.
-/
open Nat

/-
  Functions on inductive types are defined using *recursion* and *pattern matching*.
-/
def isZero': Nat → Bool := λ n =>
  match n with
  | zero => true
  | succ m => false

def isZero (n : Nat) : Bool := 
  match n with 
  | zero => true 
  | succ m => false 

/-
  The following is a shorthand syntax for the above.
  Note that in the `succ n` pattern we don't do use `n` in the definition, 
  so we can put an underscore instead of giving it a name.
-/
def isZero'' : Nat → Bool 
| zero => true 
| succ _ => false

def factorial'': Nat → Nat := λ n => 
  match n with
  | zero => 1
  | succ k => n * (factorial'' k)

#check factorial''
#eval factorial'' 5

def factorial : Nat → Nat 
| zero => 1  
| succ m => (succ m) * factorial (m)

def factorial' : Nat → Nat 
| 0 => 1 
| m + 1 => (m + 1) * factorial m



/-
  Definitions by pattern matching can also be recursive.
-/
def nthSum : Nat → Nat
| zero => zero
| succ n => (succ n) + nthSum n

-- def nthSum': Nat → Nat
-- | 0 => 0
-- | k + 1 => k + 1 + nthSum' k

/-
  There are builtin notations like `0` for `zero` and `n + 1` for `succ n` but they are the same thing under the hood.
-/
def nthSum' : Nat → Nat
| 0 => 0
| n + 1 => (n + 1) + nthSum n


/-
  Warning. By default, all functions need to terminate. 
  If it can not tell that function terminate, Lean will give an error.
  This may happen when the function indeed does not terminate (as in the example below),
  or when Lean cannot figure out how to prove termination on its own.
-/

-- def nonterminating : Nat → Nat 
-- | n => nonterminating (n + 1)

/-
  **Exercise 5**:
    Using pattern matching, define the `factorial` function, computing the factorial of a natural number.
-/
-- def factorial : Nat → Nat
--   | 0 => 1 
--   | n + 1 => (n + 1) * factorial n 

#check Nat.recOn

/-
  We can also prove theorems in Lean. This is not the subject of today's lab, 
  but if your definition is correct the line below will not give an error
  and will be a formal proof of the fact that `factorial 5 = 120`.
-/
example : factorial 5 = 120 := rfl





/-
  Another common type in a functional programming, builtin in Lean, is the `Option` type, which is parametric in a type.
  Given a type `α`, `Option α` has two constructors, `none : Option α` and `some : α → Option α`.
  A term of type `Option α` is either `none` or of the form `some a`, for some `a : α`.
  `Option` is commonly used to indicate error values, with `none` representing an error 
  and `some a` a valid value.
-/

namespace Hidden

  inductive Option (α : Type) where 
  | none : Option α 
  | some : α → Option α
-- Maybe din Haskell 
end Hidden 

/-
  Subtraction on natural numbers is ill-behaved, in the sense that one cannot subtract m from n when `n < m`.
  Lean's builtin subtraction returns `0` for `n - m` when `n < m`. 
  **Exercise 6**: 
    Define the `sub?` function below, returning the right results of `n - m` when `n ≥ m` and an error otherwise.
  Hint:
    Use the `if ... then ... else ...` expression.
-/

#check @List.tail? 

def sub?': Nat → Nat → Option Nat := λ a b => if a >= b then some (a - b) else none

#check Option

def xxx := some 3
def xxx': Option Nat := none
#check xxx
#check xxx'


def sub? : Nat → Nat → Option Nat := fun n m => if n < m then none else some (n - m)
/-
  **Exercise 7**: 
    Define, without using the builtin `Nat.add` or `+`, the `myAdd` function below, adding two natural numbers.
-/
-- def myAdd' (n m : Nat) : Nat := 

def myAdd : Nat → Nat → Nat
| m, 0 => m
| m, n + 1 => 1 + myAdd m n

/-
  Like with `factorial`, if your definition is correct, the example below should give no errors.
-/
example : myAdd 28 49 = 77 := rfl 
#check myAdd
#eval myAdd 999 999


/-
  Depending on the way you defined `myAdd`, one of the `example`s below will probably be correct, 
  but the other will still give an error,
  so you will have proved either that `0 + n = n` or that `n + 0 = n` for all natural numbers `n`.
  Uncomment both examples to see what happens.
-/
-- 0 + n = n
-- example (n : Nat) : myAdd 0 n = n := rfl 

-- n + 0 = n
-- example (n : Nat) : myAdd n 0 = n := rfl

#check Nat.add_zero 
#check Nat.add_succ

