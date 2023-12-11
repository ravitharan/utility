
def DIR(obj):
    members = [ x for x in dir(obj) if x[0:2] != '__' ]
    print('\n'.join(members))
