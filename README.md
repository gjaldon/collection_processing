# ProfileMatrix

Compares using `Enum`, `Stream` and `Flow` functions for generating a 2D matrix from a range.

Run it with:
```
iex> ProfileMatrix.run()
```

Running it on my local machine, I got the following output:

```
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.9.0
Erlang 21.1.2

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 21 s

Benchmarking enum...
Benchmarking flow...
Benchmarking stream...

Name             ips        average  deviation         median         99th %
flow            0.21         4.71 s     ±0.00%         4.71 s         4.71 s
enum           0.170         5.88 s     ±0.00%         5.88 s         5.88 s
stream         0.102         9.77 s     ±0.00%         9.77 s         9.77 s

```

We can observe and deduce the following from the results:
- `Flow` > `Enum` > `Stream` in terms of performance
- Although the `Flow` version uses all cores, it is only slightly faster than `Enum` in this case. This
is likely because not much of the work is parallelizable plus the overhead of communicating between processes (I imagine, to a lesser degree).
- `Stream` is slower in this case.
  - There's a common misconception about how `Stream` speeds up working on a collection of data. **The main takeaway**
here is that it does not speed up computation because it does not "parallelize" work. `Stream` is lazy loading for handling huge or infinite collections. That way, you don’t need to load the whole collection into memory when you want to process it, which is impossible for infinitely huge collections and very expensive for huge collections.
  - This is likely because of the bookkeeping it needs to do that `Enum` doesn't have to. Because of this, `Stream` will always be slower than `Enum` by some constant factor
- If we want faster data processing over a collection of data in Elixir (outside of using more efficient data structures), we use `Flow` or some other way of parallelizing the work.
  - This case is a poor example for where `Flow` is good for. If we did heavier computations inside the `map`s, we would see greater disparity in performance between the different versions in favor of `Flow`.
