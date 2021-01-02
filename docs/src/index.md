# StandardYoungTableaux

## Overview

Some stuff for standard Young tableaux:

- generation of all SYTx of a given shape

- count of all SYTx of a given shape

- uniform sampling of SYTx

- Robinson-Schensted(-Knuth) correspondence

- conversion to and from ballot sequences

- conversion to and from paths of integer partitions on the Young graph

- Plancherel growth process

![](http://stla.github.io/stlapblog/posts/assets/img/young_yng_path.png)

```
julia> syt = StandardYoungTableau([[1,2], [3,4], [5]])
julia> SYT2YoungPath(syt)
5-element Array{IPartition,1}:
 IPartition(1, [1])
 IPartition(2, [2])
 IPartition(3, [2, 1])
 IPartition(4, [2, 2])
 IPartition(5, [2, 2, 1])
```


## Member functions

```@autodocs
Modules = [StandardYoungTableaux]
Order   = [:type, :function]
```
