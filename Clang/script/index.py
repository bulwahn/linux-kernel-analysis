# This script plots the graph of top 10 warning types.

import matplotlib.pyplot as plt

def filereader(p):
    ls = []
    fl = open(p,"r")

    for i in fl:
        if "warning" in i:
            ls.append(i)

    fl.close()
    return ls

def graph(d_warn):

    val = list(d_warn.values())
    k = list(d_warn.keys())

    plt.xlabel('Warning Types')
    plt.ylabel('Frequency of each warning type')
    plt.bar(range(10), val[:10], align='center')
    plt.xticks(range(10), k[:10], size = 6.5)

    plt.show()

def main():
    lst     = []  # list of all warnings
    ls_uniq = []  # list of unique warnings
    ls_warn = []  # list of unique warning types
    dic_warn = {} # Key - warning type Value - occurance

    path = "../warning_file" # path of the file

    lst = filereader(path)

    #Unique list of warnings and type of it
    for j in lst:
        if j not in ls_uniq:
            ls_uniq.append(j)
            k = j.find('[')
            ls_warn.append(j[k+3:len(j)-2])

    # Dictionary having the frequency of warnings
    for w in ls_warn:
        cnt = 0
        for l in lst:
            if w in l:
                cnt += 1
        dic_warn[w] =  cnt

    # Plot only top 10 warning types
    ls_pop_fr = sorted(dic_warn.values(), reverse = True)
    dic_pop_warn = {}
    for i in ls_pop_fr:
        for k in dic_warn:
            if dic_warn[k] == i:
                dic_pop_warn[k] = i

    graph(dic_pop_warn)

if __name__ == "__main__":
    main()
