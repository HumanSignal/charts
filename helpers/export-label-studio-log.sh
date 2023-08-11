#!/bin/bash

log_path='./label-studio-log'

since_args=""
#-n namespace: The namespace that label-studio is installed in.
#-d log_path: Log storage path.
#-s 24h: export logs since 24h
while getopts "n:d:s" opt_name; do
  case $opt_name in
  n) namespace=$OPTARG ;;
  d) log_path=$OPTARG ;;
  s) since=$OPTARG ;;
  *) echo "Unknown arguments" ;;
  esac
done

if [ ! $namespace ]; then
  echo "Missing argument namespace, please add it. For example:'./export-label-studio-log.sh -n label-studio'"
  exit 1
fi

if [ ! -d $log_path/pod_log ] || [ ! -d $log_dir/pod_log_previous ] || [ ! -d $log_dir/pod_describe ]; then
  mkdir -p $log_path/pod_log
  mkdir -p $log_path/pod_log_previous
  mkdir -p $log_path/pod_describe
fi

if [ $since ]; then
  since_args="--since=$since"
fi

echo "The log files will be stored in $(readlink -f $log_path)"

function export_app_log() {
  # export pod logs
  for pod in $1; do
    for container in nginx app; do
      # Check if the pod has been restarted
      if [ $(kubectl get pod $pod -n $namespace --output=jsonpath={.status.containerStatuses[0].restartCount}) == 0 ]; then
        echo "Export log of $pod container $container"
        mkdir -p $log_path/pod_log/$pod
        kubectl logs $pod -n $namespace -c $container ${since_args} >$log_path/pod_log/$pod/$container.log
      else
        echo "Export log of $pod container $container"
        mkdir -p $log_path/pod_log/$pod
        kubectl logs $pod -n $namespace -c $container -p ${since_args} >$log_path/pod_log_previous/$pod/$container.log
        kubectl logs $pod -n $namespace -c $container ${since_args} >$log_path/pod_log/$pod/$container.log
      fi
    done
    echo -e "Export describe of $pod\n"
    kubectl describe pod $pod -n $namespace >$log_path/pod_describe/$pod.log
  done
}

function export_rqworker_log() {
  # export pod logs
  for pod in $1; do
    # Check if the pod has been restarted
    if [ $(kubectl get pod $pod -n $namespace --output=jsonpath={.status.containerStatuses[0].restartCount}) == 0 ]; then
      echo "Export log of $pod"
      kubectl logs $pod -n $namespace ${since_args} >$log_path/pod_log/$pod.log
    else
      echo "Export log of $pod"
      kubectl logs $pod -n $namespace -p ${since_args} >$log_path/pod_log_previous/$pod.log
      kubectl logs $pod -n $namespace ${since_args} >$log_path/pod_log/$pod.log
    fi
    echo -e "Export describe of $pod\n"
    kubectl describe pod $pod -n $namespace >$log_path/pod_describe/$pod.log
  done
}

# export label-studio app log
pods=$(kubectl get pod -n $namespace -l app.kubernetes.io/name=ls-app --output=jsonpath={.items..metadata.name})
if [ ${#pods} == 0 ]; then
  echo "There is no label-studio app instance in the namespace $namespace. Exiting..."
  exit 1
else
  export_app_log "${pods[*]}"
fi

# export label-studio rqworkers log
pods=$(kubectl get pod -n $namespace -l app.kubernetes.io/part-of=label-studio --output=jsonpath={.items..metadata.name})
if [ ${#pods} == 0 ]; then
  echo "There is no label-studio rqworker instances in the namespace $namespace."
else
  export_rqworker_log "${pods[*]}"
fi

# Export Service and PVC describes
for resource in svc pvc ing serviceaccount; do
  kubectl describe $resource -n $namespace -l app.kubernetes.io/name=ls-app >"$log_path/${resource}_describe.log"
  echo -e "Export describe of $resource\n"
done

tar zcf $log_path.tar.gz $log_path

echo "The compressed logs are stored in $(readlink -f $log_path.tar.gz)"
