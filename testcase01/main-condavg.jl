using Distributed
using Jlsca.Sca
using Jlsca.Trs
@everywhere using Jlsca.Sca
@everywhere using Jlsca.Trs

# our vanilla  main function
function gofaster()
  if length(ARGS) < 1
    print("no input trace\n")
    return
  end

  filename = "$(ARGS[1])"
  attack = AesSboxAttack()
  analysis = CPA()
  params = DpaAttack(attack, analysis)
  
  # do an all-bit ABS-sum attack
  params.analysis.leakages = [Bit(i) for i in 0:7]

  @everywhere begin
      trs = InspectorTrace($filename)

      setPostProcessor(trs, CondAvg(SplitByTracesBlock()))
  end

  numberOfTraces = length(trs)
  if length(ARGS) > 1
    numberOfTraces = min(parse(ARGS[2]), numberOfTraces)
  end

  ret = sca(DistributedTrace(), params, 1, numberOfTraces)

  return ret
end

@time gofaster()
