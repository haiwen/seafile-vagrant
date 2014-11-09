from fabric.api import task, run, cd

@task
def build():
    run('uname -a')
    # with cd('/vagrant/seafile-client'):
    #     run('[ -f CMakeCache.txt ] || cmake -N ninja 

