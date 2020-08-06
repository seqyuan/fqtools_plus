# fqtools_plus
# features


# get fqtools_plus

# compile from source

```
Usage:
fqtools_plus filter [options]  <input fq1.gz> <input fq2.gz> <adapter_r1> <adapter_r2> <out clean fq1.gz> <out clean fq2.gz> 
[options]
    --c       INT     cut sequence(截取片段长度), default [0 not cut sequence]
    --start   INT     start site(起始位点，从0开始), default [0]
    --q       INT     cut data cutoff(截取数据量大小), default [0 not cut data]
    --ql      INT     base quality lower limit, default [19]
    --qh      INT     base quality higher limit, default [30]
    --Q       FLOAT   low-quality base rate limit, default [0.5]
    --n       FLOAT   N rate limit, default [0.05]
    --AT      FLOAT   single pair read High AT content, default [0.8]
    --GC      FLOAT   single pair read High GC content, default [0.8]
    --polyAT  INT     poly A/T length(多聚AT的长度), default [0]
    --i       INT     ASCII value stands for qulity 0, default [33]
    --m       INT     num thread, default 1.当使用多线程时，为了更好的性能：使用数据量截取参数时，必须>=4线程，否则默认为非多线程运行。不使用数据量截取参数时，必须>=3线程，否则默认为非多线程运行
    --adapt1   string  adapt r1 sequence, if use this parameter, not use <adapter_r1> <adapter_r2>
    --adapt2   string  adapt r2 sequence, if use this parameter, not use <adapter_r1> <adapter_r2>
    -min_overlap INT    default 5 Minimum overlap length. If the overlap between the read and the adapter is shorter than LENGTH, the read is not modified.
    --zip     string  zip software, default gzip
    --polyN   string  A,T,G,C
    --tailen  INT     tail len
    --trim
[example]
fqtools_plus filter [options] test_R1.fq.gz test_R2.fq.gz test_R1.adapter.txt.gz test_R2.adapter.txt.gz test_R1.clean.fq.gz test_R2.clean.fq.gz
fqtools_plus filter [options] --adapt1 AGATCGGAAGAGCACACGTCTGAACTCCAGTCA --adapt2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT test_R1.fq.gz test_R2.fq.gz test_R1.clean.fq.gz test_R2.clean.fq.gz
";
```

