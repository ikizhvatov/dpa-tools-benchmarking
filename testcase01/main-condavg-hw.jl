using Distributed
@everywhere using Jlsca.Sca
@everywhere using Jlsca.Trs

if length(ARGS) < 1
  print("no input trace\n")
  return
end

filename = "$(ARGS[1])"
attack = AesSboxAttack()
analysis = CPA()
params = DpaAttack(attack, analysis)

# do an HW attack
params.analysis.leakages = [HW()]

@everywhere begin
    trs = InspectorTrace($filename)
    getTrs() = trs
end

numberOfTraces = length(trs)
if length(ARGS) > 1
  numberOfTraces = min(parse(ARGS[2]), numberOfTraces)
end

@time ret = sca(DistributedTrace(getTrs), params, 1, numberOfTraces)


