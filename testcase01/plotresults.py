#!/usr/bin/env python

# Plotting results of DPA tools benchmarkkng

import numpy as np
import matplotlib.pyplot as plt

def plotBars(labels, timingsLaptop, timingsDesktop, title, filename):
    # based on http://benalexkeen.com/bar-charts-in-matplotlib/

    N = len(labels)
    ind = np.arange(N) 
    width = 0.35 

    plt.figure()
    plt.bar(ind, timingsLaptop, width, label='Laptop', zorder=5)
    plt.bar(ind+width, timingsDesktop, width, label='Desktop', zorder=5)

    plt.gca().yaxis.grid(which='both')
    plt.legend()
    plt.yscale('log')
    plt.ylabel('Runtime, s')
    plt.xticks(ind + width / 2, labels)
    plt.title(title)
    plt.savefig(filename)

labels_hw = ['ChipWhisperer', 'Daredevil', 'Inspector', 'Jlsca', 'Jlsca-condavg']
labels_abs = ['Daredevil', 'Inspector', 'Jlsca', 'Jlsca-condavg']

cpahw_laptop   = [1109, 128, 124, 60, 19]
cpahw_desktop  = [840, 54, 73, 32, 11]
cpaabs_laptop  = [980, 847, 381, 20]
cpaabs_desktop = [392, 377, 189, 12]

plotBars(labels_hw, cpahw_laptop, cpahw_desktop, "HW CPA", "timings-cpahw.png")
plotBars(labels_abs, cpaabs_laptop, cpaabs_desktop, "All-bits CPA", "timings-cpaabs.png")

exit()