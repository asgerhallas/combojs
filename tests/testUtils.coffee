module.exports.run_only = (module, start, end) ->
    e = module.exports
    ks = Object.keys e
    if not start? then start = ks.length-1
    if not end? then end = start

    fst = if start < 0 then ks.length+start else start
    lst = if end < 0 then ks.length+end else end

    console.log "running narrowed set of set cases: case #{fst} to #{lst}"
    module.exports = {}
    for i in [fst..lst]
      key = ks[i]
      module.exports[key] = e[key]
    e