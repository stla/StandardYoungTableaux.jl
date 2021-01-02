module StandardYoungTableaux

import Distributions

export IPartition
export StandardYoungTableau
export dualSYT
export SYT2ballot
export ballot2SYT
export allSYTx
export firstSYT
export nextSYT
export hooks
export hooklengths
export countSYTx
export RS
export SYT2YoungPath
export YoungPath2SYT
export randomSYT
export randomYoungPath

"""
    IPartition(partition)

Defines an integer partition.

# Argument

- `partition`: vector of positive integers in decreasing order 
"""
struct IPartition
  n::Int64
  partition::Vector{Int64}

  function IPartition(partition::Vector{Int64}, check::Bool = true)
    partition = filter(!=(0), partition)
    if check
      if any(diff(partition) .> 0)
        throw(ArgumentError("Partition entries must be decreasing."))
      end
      if !isempty(partition)
        partition[end] >= 1 ||
          throw(ArgumentError("Found non-positive entry in partition."))
      end
    end
    return new(sum(partition), partition)
  end
end

function _jaggedTranspose(aa)
  out = Vector{Vector{Int64}}(undef, 0)
  while !isempty(aa)
    push!(out, map(x -> x[1], aa))
    aa = filter(x -> !isempty(x), map(x -> x[2:end], aa))
  end
  return out
end

function _checkSYTrows(tableau)
  all(map(row -> all(diff(row) .> 0), tableau))
end

function _isSYT(tableau) # isSYT([[1], [2,3]]) is true ! - ça ne check pas la shape
  entries = vcat(tableau...)
  return issetequal(entries, 1:length(entries)) &&
         _checkSYTrows(tableau) &&
         _checkSYTrows(_jaggedTranspose(tableau))
end

"""
    StandardYoungTableau(tableau)

Defines a standard Young tableau.

# Argument
- `tableau`: a vector of vectors of positive integers
"""
struct StandardYoungTableau
  shape::IPartition
  tableau::Vector{Vector{Int64}}

  function StandardYoungTableau(tableau::Vector{Vector{Int64}}, check::Bool = true)
    shape = map(length, tableau)
    if check
      if any(shape .== 0) || any(diff(shape) .> 0)
        throw(ArgumentError("Invalid shape."))
      end
      if !_isSYT(tableau)
        throw(ArgumentError("Not a valid tableau."))
      end
    end
    return new(IPartition(shape, false), tableau)
  end
end

"""
    dualSYT(syt)

Dual (conjugate) standard Young tableau.

# Argument
- `syt`: a standard Young tableau
"""
function dualSYT(syt::StandardYoungTableau)
  return StandardYoungTableau(_jaggedTranspose(syt.tableau), false)
end

function _isBallotSequence(s::Vector{Int64}) # https://oeis.org/A000085
  if s[1] != 1 || any(s .<= 0)
    return false
  end
  for k = 1:length(s)
    init = s[1:k]
    for r = 1:maximum(init) # erreur dans R, faut partir de r=1
      if length(findall(==(r), init)) < length(findall(==(r + 1), init))
        return false
      end
    end
  end
  return true
end

function _syt2ballot(tableau)
  N = sum(map(length, tableau))
  a = Int64[]
  for i = 1:N
    k = 0
    j = Int64[]
    while isempty(j)
      k += 1
      j = findall(==(i), tableau[k])
      if !isempty(j)
        push!(a, k)
      end
    end
  end
  return a
end

"""
    SYT2ballot(syt)

Ballot sequence corresponding to a standard Young tableau.

# Argument
- `syt`: a standard Young tableau
"""
function SYT2ballot(syt::StandardYoungTableau)
  return _syt2ballot(syt.tableau)
end

function _ballot2syt(a::Vector{Int64})
  tableau = repeat([Int64[]], maximum(a))
  for i = 1:length(a)
    tableau[a[i]] = vcat(tableau[a[i]], i)
  end
  return tableau
end

"""
    ballot2SYT(b)

Standard Young tableau corresponding to a ballot sequence.

# Argument
- `b`: a ballot sequence (vector of integers)
"""
function ballot2SYT(b::Vector{Int64})
  if !_isBallotSequence(b)
    error("Not a ballot sequence.")
  end
  return StandardYoungTableau(_ballot2syt(b), false)
end

function _ballot(lambda, a, more)
  N = sum(lambda)
  it = N
  if more
    lambda = zeros(Int64, N)
    lambda[1] = 1
    isave = 0
    for i = 2:N
      lambda[a[i]] += 1
      if a[i] < a[i-1]
        isave = i
        break
      end
    end
    if isave == 0
      return (a = a, more = false)
    end
    it = lambda[a[isave]+1]
    for j = 0:(N-1)
      i = N - j
      if lambda[i] == it
        a[isave] = i
        lambda[i] -= 1
        it = isave - 1
        break
      end
    end
  end # end of 'if more'
  lambda0 = zeros(Int64, N)
  lambda0[1:length(lambda)] = lambda
  lambda = lambda0
  k = 1
  ir = 1
  while true
    if N < ir
      break
    end
    if lambda[ir] != 0
      a[k] = ir
      lambda[ir] -= 1
      k += 1
      ir += 1
      continue
    end
    if it < k
      break
    end
    ir = 1
  end
  if N == 1
    return (a = a, more = false)
  end
  for j = 1:(N-1)
    if a[j+1] < a[j]
      return (a = a, more = true)
    end
  end
  return (a = a, more = false)
end

"""
    allSYTx(lambda)

All standard Young tableaux of a given shape.

# Argument
- `lambda`: an integer partition

# Example

    lambda = IPartition([3, 1])
    allSYTx(lambda)
"""
function allSYTx(lambda::IPartition)
  (a, more) = _ballot(lambda.partition, zeros(Int64, lambda.n), false)
  As = [copy(a)]
  while more
    (a, more) = _ballot(lambda.partition, a, true)
    push!(As, copy(a))
  end
  return map(ballot2syt, As)
end

function _islastsyt(tableau)
  a = _syt2ballot(tableau)
  N = length(a)
  for j = 1:(N-1)
    if a[j+1] < a[j]
      return false
    end
  end
  return true
end

function _firstsyt(lambda, a)
  lambda = filter(!=(0), lambda) # dans R je ne fais pas ça mais ça marche quand même
  N = sum(lambda)
  if N == 1
    return [1]
  end
  it = N
  lambda0 = zeros(Int64, N)
  lambda0[1:length(lambda)] = lambda
  lambda = lambda0
  k = 1
  ir = 1
  while true
    if N < ir
      break
    end
    if lambda[ir] != 0
      a[k] = ir
      lambda[ir] -= 1
      k += 1
      ir += 1
      continue
    end
    if it < k
      break
    end
    ir = 1
  end
  return _ballot2syt(a)
end

function _nextsyt(tableau)
  if _islastsyt(tableau)
    return nothing
  end
  a = _syt2ballot(tableau)
  N = sum(map(length, tableau))
  lambda = zeros(Int64, N)
  lambda[1] = 1
  isave = 0
  for i = 2:N
    lambda[a[i]] += 1
    if a[i] < a[i-1]
      isave = i
      break
    end
  end
  if isave == 0
    return _ballot2syt(a)
  end
  it = lambda[a[isave]+1]
  for j = 0:(N-1)
    i = N - j
    if lambda[i] == it
      a[isave] = i
      lambda[i] -= 1
      it = isave - 1
      break
    end
  end
  return _firstsyt(lambda, a)
end

"""
    firstSYT(lambda)

The 'first' standard Young tableau of a given shape.

# Argument
- `lambda`: an integer partition
"""
function firstSYT(lambda::IPartition)
  return StandardYoungTableau(
    _firstsyt(lambda.partition, zeros(Int64, lambda.n)), 
    false
  )
end


"""
    nextSYT(syt)

The 'next' standard Young tableau.

# Argument
- `syt`: a standard Young tableau

# Example

    y = firstSYT(IPartition([4, 2]))
    nextSYT(y)
"""
function nextSYT(syt::StandardYoungTableau)
  return StandardYoungTableau(_nextsyt(syt.tableau), false)
end

function _dualPartition(lambda)
  return map(i -> length(findall(>=(i), lambda)), 1:lambda[1])
end

"""
    hooks(lambda)

The hooks of a partition.

# Argument
- `lambda`: an integer partition
"""
function hooks(lambda::IPartition)
  partition = lambda.partition
  dlambda = _dualPartition(partition)
  l = length(partition)
  out = Vector{Vector{Vector{Int64}}}(undef, l)
  for i = 1:l
    out[i] = Vector{Vector{Int64}}(undef, partition[i])
    for j = 1:partition[i]
      out[i][j] = [0; partition[i] - j + 1]
    end
  end
  for j = 1:length(dlambda)
    for i = 1:dlambda[j]
      out[i][j][1] = dlambda[j] - i + 1
    end
  end
  return out
end

"""
    hooklengths(lambda)

The hook lengths of a partition.

# Argument
- `lambda`: an integer partition
"""
function hooklengths(lambda::IPartition)
  h = hooks(lambda)
  map(x -> vcat((map(y -> sum(y) - 1, x))...), h)
end

"""
    countSYTx(lambda)

Number of standard Young tableaux of a given shape.

# Argument
- `lambda`: an integer partition, the shape

# Example

    lambda = IPartition([4, 2])
    countSYTx(lambda)
    length(allSYTx(lambda))
"""
function countSYTx(lambda::IPartition)
  numterms = Int64[]
  denterms = filter(>=(2), vcat(hooklengths(lambda)...))
  for i = 2:lambda.n
    idx = findfirst(==(i), denterms)
    if isnothing(idx)
      push!(numterms, i)
    else
      deleteat!(denterms, idx)
    end
  end
  return numerator(prod(numterms) // prod(denterms))
end

function _bump(P, Q, e, i)
  if isempty(P)
    return (P = [[e]], Q = [[i]])
  end
  p = P[1]
  if e > last(p)
    P[1] = vcat(p, e)
    Q[1] = vcat(Q[1], i)
    return (P = P, Q = Q)
  else
    j = findfirst(!, p .< e)
    w = p[j]
    P[1][j] = e
    b = _bump(P[2:end], Q[2:end], w, i)
    return (P = vcat([P[1]], b.P), Q = vcat([Q[1]], b.Q))
  end
end

"""
    RS(sigma)

Pair of standard Young tableaux given by the Robinson-Schensted(-Knuth) correspondence from a permutation.

# Argument
- `sigma`: a permutation given as a vector of integers

# Example

    RS([3, 4, 1, 2])
"""
function RS(sigma)
  if !issetequal(sigma, 1:length(sigma))
    error("`sigma` is not a permutation")
  end
  out = _bump([], [], sigma[1], 1)
  for i = 2:length(sigma)
    out = _bump(out.P, out.Q, sigma[i], i)
  end
  return (P = StandardYoungTableau(out.P, false), Q = StandardYoungTableau(out.Q, false))
end


function _whichRow(tableau, x)
  idx = findfirst(==(x), tableau[1])
  i = 1
  while isnothing(idx)
    i += 1
    idx = findfirst(==(x), tableau[i])
  end
  return i
end

"""
    SYT2YoungPath(syt)

Path of the Young graph corresponding to a standard Young tableau.

# Argument
- `syt`: a standard Young tableau

# Example

    y = StandardYoungTableau([[1,3,4], [2]])
    SYT2YoungPath(y)
"""
function SYT2YoungPath(syt::StandardYoungTableau)
  N = syt.shape.n
  path = Vector{Vector{Int64}}(undef, N)
  path[1] = vcat(1, zeros(Int64, length(syt.tableau) - 1))
  for k = 2:N
    part = copy(path[k-1])
    i = _whichRow(syt.tableau, k)
    part[i] += 1
    path[k] = part
  end
  return map(x -> IPartition(x, false), path)
end

"""
    YoungPath2SYT(path)

Standard Young tableau corresponding to a path of the Young graph.

# Argument
- `path`: a vector of integers partitions forming a path of the Young graph

# Example

    y = StandardYoungTableau([[1,3,4], [2]])
    path = SYT2YoungPath(y)
    YoungPath2SYT(path)
"""
function YoungPath2SYT(path::Vector{IPartition})
  Ns = map(x -> x.n, path)
  N = length(path)
  if any(Ns .!= 1:N)
    error(
      "Invalid path. The n-th element of the path must be a partition of n."
    )
  end
  if N == 1
    return StandardYoungTableau([[1]], false)
  end
  incrmts = diff(map(x -> length(x.partition), path))
  if any((incrmts .!= 0) .* (incrmts .!= 1))
    error("Invalid path.")
  end
  l = length(path[end].partition)
  path2 = zeros(Int64, l, N)
  for i = 1:N
    part_i = path[i].partition
    path2[1:length(part_i), i] = part_i
  end
  diffs = diff(path2, dims = 2)
  check = mapslices(
    x -> sum(x) == 1 && all((x .== 0) .| (x .== 1)), diffs, dims = 1
  )
  if !all(check)
    error("invalid path")
  end
  tableau = vcat([[1]], repeat([Int64[]], l - 1))
  for i = 1:(N-1)
    idx = findfirst(==(1), diffs[:, i])
    tableau[idx] = vcat(tableau[idx], i + 1)
  end
  return StandardYoungTableau(tableau, false)
end

"""
    randomSYT(lambda)

Uniformly random standard Young tableau of a given shape.

# Argument
- `lambda`: an integer partition, the shape
"""
function randomSYT(lambda::IPartition)
  partition = copy(lambda.partition)
  N = lambda.n
  a = zeros(Int64, N)
  i = 0
  k = 0
  while true
    i += 1
    for j in 1:partition[i]
      a[j] += 1
      k += 1
    end
    if N <= k
      break
    end
  end
  for m in 1:N
    local i, j
    while true
      i = rand(1:a[1])
      j = rand(1:partition[1])
      if i <= a[j] && j <= partition[i]
        break
      end
    end
    while true
      ih = a[j] + partition[i] - i - j
      if ih == 0
        break
      end
      k = rand(1:ih)
      if k <= (partition[i] - j)
        j += k
      else
        i += k - partition[i] + j
      end
    end
    partition[i] -= 1
    a[j] -= 1
    a[N - m + 1] = i
  end
  return StandardYoungTableau(_ballot2syt(a), false)
end

function _connectedPartitions(partition0)
  partition = copy(partition0)
  partition[1] += 1
  out = [partition]
  for i in 2:length(partition0)
    if partition0[i] < partition0[i - 1]
      partition = copy(partition0)
      partition[i] += 1
      push!(out, partition)
    end
  end
  return vcat(out, [vcat(partition0, 1)])
end

"""
    randomYoungPath(n)

Samples a path of the Young graph according to the Plancherel growth process.

# Argument
`n`: a positive integer, the size of the path to be sampled

# Example

    path = randomYoungPath(5)
    YoungPath2SYT(path)
"""
function randomYoungPath(n::Int64)
  path = [[1]]
  for i in 1:(n-1)
    set = _connectedPartitions(path[i])
    f_nu = countSYTx(IPartition(path[i], false))
    probs = map(p -> countSYTx(IPartition(p, false)), set) ./ ((i + 1) * f_nu)
    k = rand(Distributions.Categorical(probs))
    push!(path, set[k])
  end
  return map(x -> IPartition(x, false), path)
end

end