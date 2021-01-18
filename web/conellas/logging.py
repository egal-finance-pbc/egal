import structlog


def get_logger(name) -> structlog.types.FilteringBoundLogger:
    # Returned type is actually <class 'structlog._config.BoundLoggerLazyProxy'>
    # but type hinted as FilteringBoundLogger because of the provided interface.
    return structlog.get_logger(name=name)
