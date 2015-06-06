
from os.path import join, dirname
from fabric.api import env, task, cd, run, put
from seafile_dev import seafes

VMIP = '172.16.90.100'

env.hosts = [VMIP]
env.user = 'vagrant'
env.password = 'vagrant'

@task
def build(project=''):
    run('/vagrant/build.sh {} -f'.format(project))

@task
def runserver():
    run('/vagrant/server.sh run')

@task
def runpro():
    run('/vagrant/server.sh run_pro')

@task
def init():
    run('/vagrant/server.sh init')

@task
def gc():
    run('/vagrant/server.sh gc')

@task
def testseahub(*args):
    run('/vagrant/src/seahub/tests/seahubtests.sh test {}'.format(
        ' '.join(['"%s"' % arg for arg in args])))

@task
def runseafevents():
    with cd('/vagrant/src/seafevents'):
        run('./run.sh')
