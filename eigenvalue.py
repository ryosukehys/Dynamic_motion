import numpy as np

# パラメータの設定(m, kg)
h = 0.285
b = 0.075
t = 0.0003
mitsudo = 7930
E = 193 * 10**9
I = (b * t**3) / 12
n = 10
V = h * b * t
m = mitsudo * V / n

k = []
# バネ定数ベクトルを作る
h = h - h / (n * 2)  # モデルのため
for i in range(n):
    y = h / n
    k_i = 3 * E * I / y**3
    k.append(k_i)
print(k)

# 質量マトリックスと合成マトリックスを作成
M = []
K = []
for i in range(n):
    lm = [0] * n
    lm[i] = m
    M.append(lm)
    lk = [0] * n
    if i == 0:
        lk = [0] * n
        lk[0] = k[i] + k[i + 1]
        lk[1] = -k[i + 1]
    elif i == n - 1:
        lk[n - 1] = k[i]
        lk[i - 1] = -k[i]
    else:
        lk[i - 1] = -k[i]
        lk[i] = k[i] + k[i + 1]
        lk[i + 1] = -k[i + 1]
    K.append(lk)

M = np.array(M)
K = np.array(K)
print(M)
print(K)

# 質量マトリクスの逆行列の計算
M_inv = np.linalg.inv(M)

# 固有値と固有ベクトルの計算
omega, v = np.linalg.eig(np.dot(M_inv, K))

# 固有値の順番を昇順にソート
omega_sort = np.sort(omega)

# 固有値のソート時のインデックスを取得
# ⇒固有ベクトルと対応させるため
sort_index = np.argsort(omega)

# 固有値に対応する固有ベクトルをソート
v_sort = []
for i in range(len(sort_index)):
    v_sort.append(v.T[sort_index[i]])
v_sort = np.array(v_sort)

# 結果をコンソールに表示
koyushu = [i / (2 * 3.14) for i in np.sqrt(omega_sort)]
print(np.sqrt(omega_sort))
print(koyushu)
print(v_sort)
