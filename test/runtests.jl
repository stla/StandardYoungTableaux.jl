using StandardYoungTableaux
using Test

function sameVectors(v1, v2)
  return (length(v1) == length(v2)) && all(v1 .== v2)
end

function sameSYTx(syt1, syt2)
  entries1 = vcat(syt1.tableau...)
  entries2 = vcat(syt2.tableau...)
  return sameVectors(syt1.shape, syt2.shape) && sameVectors(entries1, entries2)
end

@testset "dual SYT" begin
  syt = StandardYoungTableau([1,2,6], [3,5], [4])
  dsyt = dualSYT(syt)
  ddsyt = dualSYT(dsyt)
  @test sameSYTx(syt, ddsyt)
end

@testset "random SYT" begin
  lambda = IPartition([3,2,1])
  syt = randomSYT(lambda)
  @test sameVectors(lambda.partition, syt.shape.partition)
end


