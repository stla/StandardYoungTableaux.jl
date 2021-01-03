using StandardYoungTableaux
using Test

function sameVectors(v1, v2)
  return (length(v1) == length(v2)) && all(v1 .== v2)
end

function sameSYTx(syt1, syt2)
  entries1 = vcat(syt1.tableau...)
  entries2 = vcat(syt2.tableau...)
  return sameVectors(syt1.shape.partition, syt2.shape.partition) && 
    sameVectors(entries1, entries2)
end

@testset "dual SYT" begin
  syt = StandardYoungTableau([[1,2,6], [3,5], [4]])
  dsyt = dualSYT(syt)
  ddsyt = dualSYT(dsyt)
  @test sameSYTx(syt, ddsyt)
end

@testset "random SYT" begin
  lambda = IPartition([3,2,1])
  syt = randomSYT(lambda)
  @test sameVectors(lambda.partition, syt.shape.partition)
end

@testset "enumeration" begin
  lambda = IPartition([5,2,1])
  sytx = allSYTx(lambda)
  @test length(sytx) == countSYTx(lambda)
  @test sameSYTx(sytx[1], firstSYT(lambda))
  @test sameSYTx(sytx[2], nextSYT(sytx[1]))
  @test isnothing(nextSYT(last(sytx)))
end

@testset "growth process" begin
  syt = StandardYoungTableau([[1,2,6], [3,5], [4]])
  path = SYT2YoungPath(syt)
  @test sameSYTx(syt, YoungPath2SYT(path))
end

@testset "ballot" begin
  b = [1, 1, 2, 3, 2, 1]
  syt = ballot2SYT(b)
  @test sameVectors(b, SYT2ballot(syt))
  @test sameSYTx(syt, StandardYoungTableau([[1,2,6], [3,5], [4]]))
end