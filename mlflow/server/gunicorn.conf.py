from ih_telemetry.init import initialize_telemetry

def post_fork(server, worker):
    initialize_telemetry()