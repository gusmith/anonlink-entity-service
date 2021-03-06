from entityservice.async_worker import celery, logger
from entityservice.database import DBConn, update_run_mark_complete
from entityservice.tasks import TracedTask, calculate_comparison_rate


@celery.task(base=TracedTask, ignore_results=True, args_as_tags=('run_id',))
def mark_run_complete(run_id, parent_span=None):
    log = logger.bind(run_id=run_id)
    log.debug("Marking run complete")
    with DBConn() as db:
        update_run_mark_complete(db, run_id)
    calculate_comparison_rate.delay()
    log.info("Run marked as complete")
