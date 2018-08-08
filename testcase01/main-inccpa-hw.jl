using Jlsca.Sca
using Jlsca.Trs

# our vanilla  main function
function gofaster()
  if length(ARGS) < 1
    @printf("no input trace\n")
    return
  end

  filename = ARGS[1]
  attack = AesSboxAttack()
  analysis = IncrementalCPA()
  params = DpaAttack(attack, analysis)
  
  # do the classical CPA HW attack
  params.analysis.leakages = [HW()]

  @everyworker begin
      using Jlsca.Trs
      trs = InspectorTrace($filename)

      setPostProcessor(trs, IncrementalCorrelation(SplitByTracesBlock()))
  end

  numberOfTraces = @fetch length(Main.trs)
  if length(ARGS) > 1
    numberOfTraces = min(parse(ARGS[2]), numberOfTraces)
  end

  ret = sca(DistributedTrace(), params, 1, numberOfTraces)

  return ret
end

@time gofaster()
