# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import scipy.stats.stats as st

df = pd.read_csv('~/Downloads/wto_atributos.csv',sep=';')
df['Pais 2014'].describe()

df['GINI'].describe()
df['PIB CeT'].describe()

st.spearmanr(df['GINI'], df['PIB CeT'])

df['GINI'].hist(bins = 30)
df['PIB CeT'].hist(bins = 30)

plt.scatter(df['GINI'], df['PIB CeT'])
plt.grid()
plt.xlabel('Gini Coefficient')
plt.ylabel('Percentage of PIB invested in C&T')
plt.title('An example of a Scatter Plot')
plt.xlim(-1,65)
plt.ylim(0,4)
plt.show()
