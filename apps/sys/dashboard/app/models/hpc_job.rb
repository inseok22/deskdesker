# frozen_string_literal: true

class HpcJob < OodCore::Job::Info
  include ActionView::Helpers::DateHelper

  attr_reader :cluster

  COMPLETED = 'completed'

  class << self
    def from_core_info(info: nil, cluster: nil)
      new(cluster: cluster, **info.to_h)
    end
  end

  def initialize(**args)
    args = args.deep_symbolize_keys
    @cluster = args[:cluster]
    super(**args)
  end

  def completed?
    status.to_s == COMPLETED
  end

  def to_h
    super.to_h.merge({ cluster:         cluster,
                       status:          status.to_s,
                       allocated_nodes: [] }).deep_stringify_keys
  end

  def to_human_display
    translations = {
      'id' => '작업 ID',
      'status' => '상태',
      'job_name' => '작업 이름',
      'job_owner' => '작업 소유자',
      'accounting_id' => '계정',
      'procs' => '프로세스',
      'queue_name' => '큐 이름',
      'wallclock_time' => '실행 시간',
      'wallclock_limit' => '시간 제한',
      'submission_time' => '제출 시간',
      'dispatch_time' => '시작 시간',
      'gpus' => 'GPU',
      'cluster' => '클러스터'
    }

    to_h.reject do |key, _value|
      key == 'native'
    end.map do |key, value|
      if ['wallclock_time', 'wallclock_limit'].include?(key)
        [key, fix_time(value)]
      else
        [key, value]
      end
    end.to_h.transform_keys { |key| translations[key] || key.humanize }.compact_blank
  end

  def fix_time(time)
    distance_of_time_in_words(time, 0, false, :only => [:minutes, :hours], :accumulate_on => :hours)
  end
end
