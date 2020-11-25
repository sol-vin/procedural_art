I tried class vs structs for Celestine::Drawable and this was the result.

Structs
```
IPS simple
           inward  62.38  ( 16.03ms) (± 1.46%)   652kB/op    8.57× slower
 mineshift-simple 534.35  (  1.87ms) (± 2.93%)  1.42MB/op         fastest
mineshift-complex   1.77  (565.20ms) (± 0.42%)  28.1MB/op  302.02× slower

IPS complex
           inward  62.10  ( 16.10ms) (± 1.34%)   652kB/op    8.55× slower
 mineshift-simple 530.98  (  1.88ms) (± 2.22%)  1.42MB/op         fastest
mineshift-complex   1.77  (565.66ms) (± 0.77%)  28.1MB/op  300.35× slower


                            user     system      total        real
inward 1                0.016692   0.000005   0.016697 (  0.016695)
inward 10               0.173321   0.003860   0.177181 (  0.169445)
inward 100              1.764812   0.008073   1.772885 (  1.671646)
inward 1000             17.744456   0.080833   17.825289 (  17.025666)
inward 10000            175.814880   0.882090   176.696970 (  168.446329)
mineshift-simple 1      0.001787   0.000010   0.001797 (  0.001798)
mineshift-simple 5      0.009035   0.000000   0.009035 (  0.009048)
mineshift-simple 10     0.024831   0.000010   0.024841 (  0.021901)
mineshift-simple 100    0.209778   0.000028   0.209806 (  0.191987)
mineshift-simple 1000   2.045399   0.011965   2.057364 (  1.889325)
mineshift-complex 1     0.569096   0.003941   0.573037 (  0.561652)
mineshift-complex 5     3.677007   0.011865   3.688872 (  3.647601)
mineshift-complex 10    7.455940   0.000000   7.455940 (  7.427058)
mineshift-complex 50    38.279670   0.011429   38.291099 (  38.059662)
```

Classes
```
IPS simple
           inward  62.71  ( 15.95ms) (± 0.61%)   658kB/op    8.93× slower
 mineshift-simple 559.92  (  1.79ms) (± 2.00%)   1.2MB/op         fastest
mineshift-complex   1.87  (535.70ms) (± 0.54%)  35.8MB/op  299.95× slower

IPS complex
           inward  62.69  ( 15.95ms) (± 1.00%)   658kB/op    8.89× slower
 mineshift-simple 557.11  (  1.79ms) (± 3.38%)   1.2MB/op         fastest
mineshift-complex   1.87  (535.95ms) (± 0.53%)  35.8MB/op  298.59× slower


                            user     system      total        real
inward 1                0.017202   0.000007   0.017209 (  0.017209)
inward 10               0.175583   0.000000   0.175583 (  0.174553)
inward 100              1.672445   0.003985   1.676430 (  1.664238)
inward 1000             16.763930   0.024179   16.788109 (  16.670360)
inward 10000            166.905785   0.497601   167.403386 (  166.236770)
mineshift-simple 1      0.001713   0.000000   0.001713 (  0.001713)
mineshift-simple 5      0.008613   0.000000   0.008613 (  0.008616)
mineshift-simple 10     0.018224   0.000000   0.018224 (  0.017881)
mineshift-simple 100    0.183747   0.000015   0.183762 (  0.178568)
mineshift-simple 1000   1.788012   0.060057   1.848069 (  1.794442)
mineshift-complex 1     0.559444   0.000007   0.559451 (  0.544530)
mineshift-complex 5     3.800017   0.008059   3.808076 (  3.712934)
mineshift-complex 10    7.779896   0.016145   7.796041 (  7.677868)
mineshift-complex 50    39.890125   0.060072   39.950197 (  39.403033)
```