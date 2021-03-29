FROM ilyde/minimal:py37-r402

LABEL maintainer="Ilyde <tony.wilson@hopenly.com>"

# Install Python
RUN conda install --quiet --yes  \
    'beautifulsoup4=4.9.*' \
    'conda-forge::blas=*=openblas' \
    'bokeh=2.3.*' \
    'bottleneck=1.3.*' \
    'cloudpickle=1.6.*' \
    'cython=0.29.*' \
    'dask=2021.3.*' \
    'dill=0.3.*' \
    'h5py=3.1.*' \
    'ipywidgets=7.6.*' \
    'ipympl=0.6.*'\
    'matplotlib-base=3.3.*' \
    'numba=0.53.*' \
    'numexpr=2.7.*' \
    'pandas=1.2.*' \
    'patsy=0.5.*' \
    'protobuf=3.15.*' \
    'pytables=3.6.*' \
    'scikit-image=0.18.*' \
    'scikit-learn=0.24.*' \
    'scipy=1.6.*' \
    'seaborn=0.11.*' \
    'sqlalchemy=1.4.*' \
    'statsmodels=0.12.*' \
    'sympy=1.7.*' \
    'vincent=0.4.*' \
    'widgetsnbextension=3.5.*'\
    'xlrd=2.0.*' && \
    conda clean --all -f -y


# Install Tensorflow
RUN pip install --quiet --no-cache-dir 'tensorflow==2.4.1'

# ffmpeg for matplotlib anim & dvipng+cm-super for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg dvipng cm-super && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# permissions for conda dir
RUN chown -R ubuntu:ubuntu  $CONDA_DIR

# permissions for ubuntu
RUN chown -R ubuntu:ubuntu /home/ubuntu

#Create Ilyde Working directory
RUN rm -R /ilyde && mkdir /ilyde && chown ubuntu:ubuntu -R /ilyde
WORKDIR /ilyde