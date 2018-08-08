""" ChipWhisperer script for benchmarking the CPA attack.
Developed from the defaut attack script by Colin O'Flynn:
https://github.com/newaetech/chipwhisperer/blob/master/software/chipwhisperer/analyzer/scripts/attack_cpa.py
Assumes that a project with the benchmarking traceset is already open.
Needs C-accelerated CPA attack lib to be manually built in software/chipwhisperer/analyzer/attacks/cpa_algorithms/c_accel
"""

import chipwhisperer as cw
from chipwhisperer.analyzer.attacks.cpa import CPA
from chipwhisperer.analyzer.attacks.cpa_algorithms.progressive_caccel import CPAProgressive_CAccel
from chipwhisperer.analyzer.attacks.models.AES128_8bit import AES128_8bit, SBox_output
from chipwhisperer.analyzer.preprocessing.add_noise_random import AddNoiseRandom

traces = self.project.traceManager()

#Example: If you wanted to add noise, turn the .enabled to "True"
self.ppmod[0] = AddNoiseRandom()
self.ppmod[0].noise = 0.05
self.ppmod[0].enabled = False

attack = CPA()
leak_model = AES128_8bit(SBox_output)
attack.setAnalysisAlgorithm(CPAProgressive_CAccel, leak_model)

attack.setTraceStart(0)
attack.setTracesPerAttack(100000)
attack.setIterations(1)
attack.setReportingInterval(100000)
attack.setTargetSubkeys([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
attack.setTraceSource(self.ppmod[0])
attack.setPointRange((0, 511))

self.results_table.setAnalysisSource(attack)
self.correlation_plot.setAnalysisSource(attack)
self.output_plot.setAnalysisSource(attack)
self.pge_plot.setAnalysisSource(attack)
attack.processTraces()
