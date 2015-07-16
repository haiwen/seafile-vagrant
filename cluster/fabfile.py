from fabric.api import env, task, cd, run

vms = [
    '172.16.2.11',
    '172.16.2.12',
]

env.hosts = vms
env.user = 'vagrant'
env.password = 'vagrant'

@task
def restart_seahub():
    with cd('/data/haiwen/seafile-server-latest'):
        run('./seahub.sh restart-fastcgi')
