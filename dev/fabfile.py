
from os.path import join, dirname
from fabric.api import env, task, cd, run, put
from seafile_dev import seafes

VMIP = '33.33.33.101'

env.hosts = [VMIP]
env.user = 'vagrant'
env.password = 'vagrant'

@task
def build(project=''):
    run('/vagrant/build.sh {}'.format(project))

@task
def runserver():
    run('/vagrant/server.sh run')

@task
def init():
    run('/vagrant/server.sh init')

@task
def gc():
    run('/vagrant/server.sh gc')
