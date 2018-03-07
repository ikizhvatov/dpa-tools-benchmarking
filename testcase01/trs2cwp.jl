using PyCall
@pyimport numpy

# Export a minimal readable ChipWhisperer project
function exportCwp(name, traces, textin, textout)
    
    (numTraces, numSamples) = size(traces)
    (numInputs,) = size(textin)
    (numOutputs,) = size(textout)
    
    # Minimal correctness check
    if numTraces != numInputs || numTraces != numOutputs
        error("Input data size mismatch")
    end
    
    # Create directory structure. Existing project with the same name will be
    # overwritten without a full cleanup, supersorry
    if !isdir(name)
        mkpath("$name/traces")
    else
        if !isdir("$name/traces")
            mkdir("$name/traces")
        end
    end

    # Write the minimal project config file
    cwpConfig = """
    [Trace Management]
    tracefile0=traces/config.cfg
    enabled0=True"""
    f = open("$name/config.cwp", "w")
    println(f, cwpConfig)
    close(f)
    
    # Write the main data files
    numpy.save("$name/traces/traces.npy", traces)
    numpy.save("$name/traces/textin.npy", textin)
    numpy.save("$name/traces/textout.npy", textout)

    # Write traceset config file
    f = open("$name/traces/config.cfg", "w")
    println(f, "[Trace Config]")
    println(f, "numTraces = $numTraces")
    println(f, "format = native")
    println(f, "numPoints = $numSamples")
    println(f, "prefix = ")
    close(f)

end

trsName = "aes128_sb_ciph_deadbeefcafebabe1122334455667788.trs"

using Jlsca.Trs

# read traceset and get it parameters
# we assume that number of data bytes is 32, of which first 16 are input and last 16 are output
trs = InspectorTrace(trsName)
(_,samples) = trs[1]
numSamples = length(samples)
numTraces = length(trs)
sampleType = eltype(samples)

# preallocate arrays
traces = Array{sampleType}(numTraces,numSamples)
textin = Array{UInt8}(numTraces,16)
textout = Array{UInt8}(numTraces,16)

# populate arrays from trs
for i in 1:numTraces
    (data,samples) = trs[i]
    traces[i,:] = samples
    textin[i,:] = data[1:16]
    textout[i,:] = data[17:32]
end
close(trs)

# export to CWP
(projectName, ) = splitext(trsName)
exportCwp("$(projectName)-cwp", traces, textin, textout)
