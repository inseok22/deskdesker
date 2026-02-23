# frozen_string_literal: true

# Helpers for the system status page /dashboard/systemstatus
module SystemStatusHelper
  def title(cluster)
    "#{cluster.metadata.title.to_s.titleize} 클러스터 상태"
  end

  def status_hash(name, active, total)
    {
      message: "#{name} 사용 가능: #{number_with_delimiter(total - active)}",
      percent: percent(active, total)
    }
  end

  def not_slurm_hash(job_adapter)
    scheduler = job_adapter.class.name.demodulize
    {
      message: "#{scheduler}에서는 클러스터 정보를 사용할 수 없습니다. 현재 Slurm 클러스터만 지원됩니다.",
      percent: -1
    }
  end

  def components_status(job_adapter)
    begin
      cluster_info = job_adapter.cluster_info
    rescue NotImplementedError
      return [not_slurm_hash(job_adapter)]
    end

    [
      status_hash('노드', cluster_info.active_nodes, cluster_info.total_nodes),
      status_hash('프로세서', cluster_info.active_processors, cluster_info.total_processors),
      status_hash('GPUs', cluster_info.active_gpus, cluster_info.total_gpus)
    ]
  end

  def percent(value, total)
    "#{(value.to_f / total * 100).round 2}%"
  end

  def valid_percent?(percent)
    percent.to_f >= 0
  end

  def active_jobs(job_adapter)
    job_adapter.info_all_each.select do |info|
      info.status.running?
    end.length
  end

  def active_job_status(job_adapter)
    num_jobs = number_with_delimiter(active_jobs(job_adapter))
    "#{num_jobs} 작업 실행 중"
  end

  def queued_jobs(job_adapter)
    job_adapter.info_all_each.select do |info|
      info.status.queued?
    end.length
  end

  def queued_job_status(job_adapter)
    num_jobs = number_with_delimiter(queued_jobs(job_adapter))
    "#{num_jobs} 작업 대기 중"
  end

  def active_job_pct(job_adapter)
    percent(active_jobs(job_adapter), active_jobs(job_adapter) + queued_jobs(job_adapter))
  end

  def queued_job_pct(job_adapter)
    percent(queued_jobs(job_adapter), active_jobs(job_adapter) + queued_jobs(job_adapter))
  end
end
