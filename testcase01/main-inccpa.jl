
using Jlsca.Sca
using Jlsca.Trs

# our vanilla  main function
function gofaster()
  if length(ARGS) < 1
    @printf("no input trace\n")
    return
  end

  filename = ARGS[1]
  direction::Direction = (length(ARGS) > 1 && ARGS[2] == "BACKWARD" ? BACKWARD : FORWARD)
  params = getParameters(filename, direction)
  if params == nothing
    params = AesSboxAttack()
  end

  params.analysis = IncrementalCPA()
  params.analysis.leakageFunctions = [x -> ((x .>> i) & 1) for i in 0:7]

  @everyworker begin
      using Jlsca.Trs
      trs = InspectorTrace($filename)
      setPostProcessor(trs, IncrementalCorrelation(SplitByTracesBlock()))
  end

  numberOfTraces = @fetch length(Main.trs)

  ret = sca(DistributedTrace(), params, 1, numberOfTraces)

  return ret
end

@time gofaster()
