var documenterSearchIndex = {"docs":
[{"location":"#StandardYoungTableaux","page":"Documentation","title":"StandardYoungTableaux","text":"","category":"section"},{"location":"#Overview","page":"Documentation","title":"Overview","text":"","category":"section"},{"location":"","page":"Documentation","title":"Documentation","text":"Some stuff for standard Young tableaux:","category":"page"},{"location":"","page":"Documentation","title":"Documentation","text":"generation of all SYTx of a given shape\ncount of all SYTx of a given shape\nuniform sampling of SYTx\nRobinson-Schensted(-Knuth) correspondence\nconversion to and from ballot sequences\nconversion to and from paths of integer partitions on the Young graph\nPlancherel growth process","category":"page"},{"location":"","page":"Documentation","title":"Documentation","text":"(Image: )","category":"page"},{"location":"","page":"Documentation","title":"Documentation","text":"julia> syt = StandardYoungTableau([[1,2], [3,4], [5]])\njulia> SYT2YoungPath(syt)\n5-element Array{IPartition,1}:\n IPartition(1, [1])\n IPartition(2, [2])\n IPartition(3, [2, 1])\n IPartition(4, [2, 2])\n IPartition(5, [2, 2, 1])","category":"page"},{"location":"#Member-functions","page":"Documentation","title":"Member functions","text":"","category":"section"},{"location":"","page":"Documentation","title":"Documentation","text":"Modules = [StandardYoungTableaux]\nOrder   = [:type, :function]","category":"page"},{"location":"#StandardYoungTableaux.IPartition","page":"Documentation","title":"StandardYoungTableaux.IPartition","text":"IPartition(partition)\n\nDefines an integer partition.\n\nArgument\n\npartition: vector of positive integers in decreasing order \n\n\n\n\n\n","category":"type"},{"location":"#StandardYoungTableaux.StandardYoungTableau","page":"Documentation","title":"StandardYoungTableaux.StandardYoungTableau","text":"StandardYoungTableau(tableau)\n\nDefines a standard Young tableau.\n\nArgument\n\ntableau: a vector of vectors of positive integers\n\n\n\n\n\n","category":"type"},{"location":"#StandardYoungTableaux.RS-Tuple{Any}","page":"Documentation","title":"StandardYoungTableaux.RS","text":"RS(sigma)\n\nPair of standard Young tableaux given by the Robinson-Schensted(-Knuth) correspondence from a permutation.\n\nArgument\n\nsigma: a permutation given as a vector of integers\n\nExample\n\nRS([3, 4, 1, 2])\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.SYT2YoungPath-Tuple{StandardYoungTableau}","page":"Documentation","title":"StandardYoungTableaux.SYT2YoungPath","text":"SYT2YoungPath(syt)\n\nPath of the Young graph corresponding to a standard Young tableau.\n\nArgument\n\nsyt: a standard Young tableau\n\nExample\n\ny = StandardYoungTableau([[1,3,4], [2]])\nSYT2YoungPath(y)\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.SYT2ballot-Tuple{StandardYoungTableau}","page":"Documentation","title":"StandardYoungTableaux.SYT2ballot","text":"SYT2ballot(syt)\n\nBallot sequence corresponding to a standard Young tableau.\n\nArgument\n\nsyt: a standard Young tableau\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.YoungPath2SYT-Tuple{Array{IPartition,1}}","page":"Documentation","title":"StandardYoungTableaux.YoungPath2SYT","text":"YoungPath2SYT(path)\n\nStandard Young tableau corresponding to a path of the Young graph.\n\nArgument\n\npath: a vector of integers partitions forming a path of the Young graph\n\nExample\n\ny = StandardYoungTableau([[1,3,4], [2]])\npath = SYT2YoungPath(y)\nYoungPath2SYT(path)\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.allSYTx-Tuple{IPartition}","page":"Documentation","title":"StandardYoungTableaux.allSYTx","text":"allSYTx(lambda)\n\nAll standard Young tableaux of a given shape.\n\nArgument\n\nlambda: an integer partition\n\nExample\n\nlambda = IPartition([3, 1])\nallSYTx(lambda)\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.ballot2SYT-Tuple{Array{Int64,1}}","page":"Documentation","title":"StandardYoungTableaux.ballot2SYT","text":"ballot2SYT(b)\n\nStandard Young tableau corresponding to a ballot sequence.\n\nArgument\n\nb: a ballot sequence (vector of integers)\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.countSYTx-Tuple{IPartition}","page":"Documentation","title":"StandardYoungTableaux.countSYTx","text":"countSYTx(lambda)\n\nNumber of standard Young tableaux of a given shape.\n\nArgument\n\nlambda: an integer partition, the shape\n\nExample\n\nlambda = IPartition([4, 2])\ncountSYTx(lambda)\nlength(allSYTx(lambda))\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.dualSYT-Tuple{StandardYoungTableau}","page":"Documentation","title":"StandardYoungTableaux.dualSYT","text":"dualSYT(syt)\n\nDual (conjugate) standard Young tableau.\n\nArgument\n\nsyt: a standard Young tableau\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.firstSYT-Tuple{IPartition}","page":"Documentation","title":"StandardYoungTableaux.firstSYT","text":"firstSYT(lambda)\n\nThe 'first' standard Young tableau of a given shape.\n\nArgument\n\nlambda: an integer partition\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.hooklengths-Tuple{IPartition}","page":"Documentation","title":"StandardYoungTableaux.hooklengths","text":"hooklengths(lambda)\n\nThe hook lengths of a partition.\n\nArgument\n\nlambda: an integer partition\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.hooks-Tuple{IPartition}","page":"Documentation","title":"StandardYoungTableaux.hooks","text":"hooks(lambda)\n\nThe hooks of a partition.\n\nArgument\n\nlambda: an integer partition\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.nextSYT-Tuple{StandardYoungTableau}","page":"Documentation","title":"StandardYoungTableaux.nextSYT","text":"nextSYT(syt)\n\nThe 'next' standard Young tableau.\n\nArgument\n\nsyt: a standard Young tableau\n\nExample\n\ny = firstSYT(IPartition([4, 2]))\nnextSYT(y)\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.randomSYT-Tuple{IPartition}","page":"Documentation","title":"StandardYoungTableaux.randomSYT","text":"randomSYT(lambda)\n\nUniformly random standard Young tableau of a given shape.\n\nArgument\n\nlambda: an integer partition, the shape\n\n\n\n\n\n","category":"method"},{"location":"#StandardYoungTableaux.randomYoungPath-Tuple{Int64}","page":"Documentation","title":"StandardYoungTableaux.randomYoungPath","text":"randomYoungPath(n)\n\nSamples a path of the Young graph according to the Plancherel growth process.\n\nArgument\n\nn: a positive integer, the size of the path to be sampled\n\nExample\n\npath = randomYoungPath(5)\nYoungPath2SYT(path)\n\n\n\n\n\n","category":"method"}]
}
