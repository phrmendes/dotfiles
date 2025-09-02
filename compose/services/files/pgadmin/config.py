ENABLE_PSQL = True
X_FRAME_OPTIONS = "SAMEORIGIN"
SHARED_STORAGE = [
    {
        "name": "dumps",
        "path": "/var/lib/pgadmin/storage/dumps",
        "restricted_access": False,
    }
]
