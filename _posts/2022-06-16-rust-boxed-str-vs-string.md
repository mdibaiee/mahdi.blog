---
layout: post
title: "What is `Box<str>` and how is it different from `String` in Rust?"
date: 2022-06-16 00:00:00
permalink: rust-box-str-vs-string/
categories: programming
author: Mahdi
---

Today I and a friend went down a rabbit hole about Rust and how it manages the heap when we use `Box`, or `String`, or `Vec`, and while we were at it, I found out there is such a thing as `Box<str>`, which might look a bit _strange_ to an untrained eye, since most of the time the `str` primitive type is passed around as `&str`.

-----

TL;DR:

`Box<str>` is a primitive, immutable `str` allocated on the heap, whereas `String` is actually a `Vec<unsigned char>`, also allocated on the heap, but allowing for removals and appendages. `Box<str>` uses less memory than `String`.

------

I will be using `rust-lldb` throughout this post to understand what is going on in the rust programs we write and run. The source code for this blog post is available on [mdibaiee/rust-memory-playground](https://github.com/mdibaiee/rust-memory-playground).

```bash
git clone git@github.com:mdibaiee/rust-memory-playground
cd rust-memory-playground
```

# The Stack

Most of the primitive data types used throughout a program, and the information about the program itself are usually allocated on the stack. Consider this simple program:

```rust
fn add_ten(a: u8) -> u8 {
    let b = 10;
    a + b
}


fn main() {
    println!("{}", add_ten(9));
}
```

Let's examine the stack when we are running `a + b` by setting a breakpoint on that line:

```
$ cargo build && rust-lldb target/debug/stack-program

(lldb) breakpoint set -f main.rs -l 3
Breakpoint 1: where = stack-program`stack_program::add_ten::h42edbf0bdcb04851 + 24 at main.rs:3:5, address = 0x0000000100001354

(lldb) run
Process 65188 launched: '/Users/mahdi/workshop/rust-memory-playground/target/debug/stack-program' (arm64)
Process 65188 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
    frame #0: 0x0000000100001354 stack-program`stack_program::add_ten::h42edbf0bdcb04851(a=5) at main.rs:3:5
   1    fn add_ten(a: u8) -> u8 {
   2        let b = 10;
-> 3        a + b
   4    }
   5
   6
   7    fn main() {
   
(lldb) frame var -L -f X
0x000000016fdfed7e: (unsigned char) a = 0x09
0x000000016fdfed7f: (unsigned char) b = 0x0A
```

Our program allocates two variables on the stack directly here. Notice that they are allocated right next to each other, their address only one bit apart. Most primitive types are allocated on the stack, and are copied when being passed around because they are small enough, so that copying them around is more reasonable than allocating them in the heap and passing around a pointer to them. In this case, `u8` can be allocated in a single byte, it would not make sense for us to allocate a pointer (which can vary in size, but are usually larger than 8 bytes). Every time you call a function, a copy of the values passed to it, along with the values defined in the function itself constitute the stack of that function.

The stack of a whole program includes more information though, such as the _backtrace_, which allows the program to know how to navigate: once I am done with this function, where should I return to? that information is available in the stack as well. Note the first couple of lines here, indicating that we are currently in `stack_program::add_then`, and we came here from `stack_program::main`, and so once we are finished with `add_then`, we will go back to `main`:

```
(lldb) thread backtrace
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
  * frame #0: 0x0000000100001350 stack-program`stack_program::add_ten::hf7dc9cccae290c37(a='\t') at main.rs:3:5
    frame #1: 0x00000001000013a8 stack-program`stack_program::main::he22b9cf577b52c34 at main.rs:8:20
    frame #2: 0x00000001000015a4 stack-program`core::ops::function::FnOnce::call_once::hd6bac0cd3fcb8c07((null)=(stack-program`stack_program::main::he22b9cf577b52c34 at main.rs:7), (null)=<unavailable>) at function.rs:227:5
    frame #3: 0x00000001000014c4 stack-program`std::sys_common::backtrace::__rust_begin_short_backtrace::hc4df46810f9a7139(f=(stack-program`stack_program::main::he22b9cf577b52c34 at main.rs:7)) at backtrace.rs:122:18
    frame #4: 0x0000000100001178 stack-program`std::rt::lang_start::_$u7b$$u7b$closure$u7d$$u7d$::hbec5b809d627978a at rt.rs:145:18
    frame #5: 0x000000010001440c stack-program`std::rt::lang_start_internal::hc453db0ee48af82e [inlined] core::ops::function::impls::_$LT$impl$u20$core..ops..function..FnOnce$LT$A$GT$$u20$for$u20$$RF$F$GT$::call_once::h485d4c2966ec30a8 at function.rs:259:13 [opt]
    frame #6: 0x0000000100014400 stack-program`std::rt::lang_start_internal::hc453db0ee48af82e [inlined] std::panicking::try::do_call::h375a887be0bea938 at panicking.rs:492:40 [opt]
    frame #7: 0x0000000100014400 stack-program`std::rt::lang_start_internal::hc453db0ee48af82e [inlined] std::panicking::try::hecad40482ef3be15 at panicking.rs:456:19 [opt]
    frame #8: 0x0000000100014400 stack-program`std::rt::lang_start_internal::hc453db0ee48af82e [inlined] std::panic::catch_unwind::haf1f664eb41a88eb at panic.rs:137:14 [opt]
    frame #9: 0x0000000100014400 stack-program`std::rt::lang_start_internal::hc453db0ee48af82e [inlined] std::rt::lang_start_internal::_$u7b$$u7b$closure$u7d$$u7d$::h976eba434e9ff4cf at rt.rs:128:48 [opt]
    frame #10: 0x0000000100014400 stack-program`std::rt::lang_start_internal::hc453db0ee48af82e [inlined] std::panicking::try::do_call::h8f2501ab92e340b0 at panicking.rs:492:40 [opt]
    frame #11: 0x0000000100014400 stack-program`std::rt::lang_start_internal::hc453db0ee48af82e [inlined] std::panicking::try::hbeb9f8df83454d42 at panicking.rs:456:19 [opt]
    frame #12: 0x0000000100014400 stack-program`std::rt::lang_start_internal::hc453db0ee48af82e [inlined] std::panic::catch_unwind::h0a9390b2202af6e9 at panic.rs:137:14 [opt]
    frame #13: 0x0000000100014400 stack-program`std::rt::lang_start_internal::hc453db0ee48af82e at rt.rs:128:20 [opt]
    frame #14: 0x0000000100001140 stack-program`std::rt::lang_start::h69bdd2191bba2dab(main=(stack-program`stack_program::main::he22b9cf577b52c34 at main.rs:7), argc=1, argv=0x000000016fdff168) at rt.rs:144:17
    frame #15: 0x0000000100001434 stack-program`main + 32
    frame #16: 0x00000001000750f4 dyld`start + 520
```

# Box, String and Vec: Pointers to Heap

There are times when we are working with data types large enough that we would really like to avoid copying them when we are passing them around. Let's say you have just copied a file that is 1,000,000 bytes (1Mb) in size. In this case it is much more memory and compute efficient to have a pointer to this value (8 bytes) rather than copying all the 1,000,000 bytes.

This is where types such as `Box`, `String` and `Vec` come into play: these types allow you to allocate something on heap, which is a chunk of memory separate from the stack that you can allocate on, and later reference those values using a pointer available on the stack.

Let's start with `Box`, the most generic one, which allows you to allocate some data on the heap, consider this example:

```rust
fn main() {
    let a = Box::new(5_u8);
    let b = 10_u8;
    println!("{}, {}", a, b);
}
```

We again use `lldb` to check out what is happening:

```
$ cargo build && rust-lldb target/debug/stack-and-heap-program

(lldb) breakpoint set -f main.rs -l 4
Breakpoint 1: where = stack-and-heap-program`stack_and_heap_program::main::ha895783273646dc7 + 100 at main.rs:4:5, address = 0x0000000100005264

(lldb) run
Process 67451 launched: '/Users/mahdi/workshop/rust-memory-playground/target/debug/stack-and-heap-program' (arm64)
Process 67451 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
    frame #0: 0x0000000100005264 stack-and-heap-program`stack_and_heap_program::main::ha895783273646dc7 at main.rs:4:5
   1    fn main() {
   2        let a = Box::new(5_u8);
   3        let b = 10_u8;
-> 4        println!("{}, {}", a, b);
   5    }
   
(lldb) frame var -L -f X
0x000000016fdfed48: (unsigned char *) a = 0x0000600000008010 "\U00000005"
0x000000016fdfed57: (unsigned char) b = 0x0A

(lldb) memory read -count 1 -f X 0x0000600000008010
0x600000008010: 0x05
```

Note that here, instead of `a` having the value `5`, has the value `0x0000600000008010`, which is a pointer to a location in memory! `lldb` is recognises that this is a pointer (note the `*` sign beside the variable type) and shows us what the memory location contains, but we can also directly read that memory location, and of course we find `5` there. The address of the heap-allocated `5` is far from the stack-allocated `10`, since stack and heap are separate parts of memory.

Using `Box` for an unsigned 8-bit value does not really make sense, the value itself is smaller than the pointer created by `Box`, however allocating on heap is useful when we have data that we need be able to pass around the program without copying it.

Turns out, `String` and `Vec` cover two of the most common cases where we may want to allocate something on heap! Let's look at what goes on behind allocating a variable of type `String`:

```rust
fn main() {
    let s = String::from("hello!");
    println!("{}", s);
}
```

And here we go again:
```
(lldb) breakpoint set -f main.rs -l 3
Breakpoint 1: where = string-program`string_program::main::h64ca96ee87b0ceaf + 44 at main.rs:3:5, address = 0x000000010000476c

(lldb) run
Process 68317 launched: '/Users/mahdi/workshop/rust-memory-playground/target/debug/string-program' (arm64)
Process 68317 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
    frame #0: 0x000000010000476c string-program`string_program::main::h64ca96ee87b0ceaf at main.rs:3:5
   1    fn main() {
   2        let s = String::from("hello!");
-> 3        println!("{}", s);
   4    }
   
(lldb) frame var -L -T
0x000000016fdfed78: (alloc::string::String) s = "hello!" {
0x000000016fdfed78:   (alloc::vec::Vec<unsigned char, alloc::alloc::Global>) vec = size=6 {
0x0000600000004010:     (unsigned char) [0] = 'h'
0x0000600000004011:     (unsigned char) [1] = 'e'
0x0000600000004012:     (unsigned char) [2] = 'l'
0x0000600000004013:     (unsigned char) [3] = 'l'
0x0000600000004014:     (unsigned char) [4] = 'o'
0x0000600000004015:     (unsigned char) [5] = '!'
  }
}
```

This is a formatted output from `lldb`, and here you can see that the `String` type is basically a `Vec<unsigned char, alloc::Global>`, let's now look at the same command but this time raw and unformatted (`-R`):

```
(lldb) frame var -L -T -R
0x000000016fdfed78: (alloc::string::String) s = {
0x000000016fdfed78:   (alloc::vec::Vec<unsigned char, alloc::alloc::Global>) vec = {
0x000000016fdfed78:     (alloc::raw_vec::RawVec<unsigned char, alloc::alloc::Global>) buf = {
0x000000016fdfed78:       (core::ptr::unique::Unique<unsigned char>) ptr = {
0x000000016fdfed78:         (unsigned char *) pointer = 0x0000600000004010
0x000000016fdfed78:         (core::marker::PhantomData<unsigned char>) _marker = {}
      }
0x000000016fdfed80:       (unsigned long) cap = 6
0x000000016fdfed78:       (alloc::alloc::Global) alloc = {}
    }
0x000000016fdfed88:     (unsigned long) len = 6
  }
}
```

Ah! I see the `ptr` field of `RawVec` with a value of `0x0000600000004010`, that is the memory address of the beginning of our string (namely the `h` of our `hello`)! There is also `cap` and `len`, which respectively stand for capacity and length, with the value 6, indicating that our string is of capacity and length 6 (the difference between the two being that a [Vec is not automatically shrunk down](https://doc.rust-lang.org/nightly/std/vec/struct.Vec.html#guarantees) in size when items are removed from it to avoid unnecessary deallocations, hence the length might be smaller than the capacity). So in a nutshell, our String is basically something like this (inspired by [std::vec::Vec](https://doc.rust-lang.org/nightly/std/vec/struct.Vec.html#guarantees)):

```
Stack:
--------------------------------
| String                       |
|     \-> Vec                  |
|          \-> (ptr, cap, len) |
|                |             |
-----------------|--------------
Heap:            v
-----------------------------
| ('h', 'e', 'l', 'l', 'o') |
-----------------------------
```

Okay, so far so good. We have `String`, which uses a `Vec` under the hood, which is represented by a pointer, capacity and length triplet.

If `String` is already heap-allocated, why would anyone want `Box<str>`!? Let's look at how `Box<str>` would be represented in memory:

```rust
fn main() {
    let boxed_str: Box<str> = "hello".into();

    println!("boxed_str: {}", boxed_str);
}
```

And `lldb` tells us:

```
0x000000016fdfed80: (alloc::boxed::Box<>) boxed_str = {
0x000000016fdfed80:   data_ptr = 0x0000600000004010 "hello"
0x000000016fdfed88:   length = 5
}
```

Okay, so a `Box<str>` is much simpler than a `String`: there is no `Vec`, and no `capacity`, and the underlying data is a fixed primitive `str` that does not allow appending or removing, so basically `Box<str>` is an immutable `String`. It is a smaller representation as well, due to the missing `capacity` field, comparing their memory size on stack using [std::mem::size_of_val](https://doc.rust-lang.org/std/mem/fn.size_of_val.html):

```rust
let boxed_str: Box<str> = "hello".into();
println!("size of boxed_str on stack: {}", std::mem::size_of_val(&boxed_str));

let s = String::from("hello!");
println!("size of string on stack: {}", std::mem::size_of_val(&s));
```

Results in:

```
size of boxed_str on stack: 16
size of string on stack: 24
```

Note that their size on heap is the same, because they are both storing the bytes for `hello` on the heap (the measurements below show all of the heap allocations of the program, and not only the string. What matters here is that these two programs have exact same heap size in total):

```
$ cargo run --bin string-dhat
    Finished dev [unoptimized + debuginfo] target(s) in 0.01s
     Running `target/debug/string-dhat`
hello
dhat: Total:     1,029 bytes in 2 blocks
dhat: At t-gmax: 1,029 bytes in 2 blocks
dhat: At t-end:  1,024 bytes in 1 blocks
dhat: The data has been saved to dhat-heap.json, and is viewable with dhat/dh_view.html

$ cargo run --bin box-str-dhat
    Finished dev [unoptimized + debuginfo] target(s) in 0.01s
     Running `target/debug/box-str-dhat`
boxed_str: hello
dhat: Total:     1,029 bytes in 2 blocks
dhat: At t-gmax: 1,029 bytes in 2 blocks
dhat: At t-end:  1,024 bytes in 1 blocks
dhat: The data has been saved to dhat-heap.json, and is viewable with dhat/dh_view.html
```
