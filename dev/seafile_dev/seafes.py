from fabric.api import task, run, cd

def _run_default(command, *a, **kw):
    """Source /etc/default/seafile-server and run the given command"""
    command = ". /etc/default/seafile-server; " + command
    return run(command, *a, **kw)


def _index_op(op):
    with cd('/vagrant/src/seafes'):
        _run_default('python -m seafes.update_repos --loglevel debug {}'.format(op))

@task
def test(*args):
    with cd('/vagrant/src/seafes'):
        _run_default('py.test ' + ' '.join(args))

@task
def update():
    _index_op('update')

@task
def clear():
    _index_op('clear')
