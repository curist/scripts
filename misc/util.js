const { popen } = std

export function exec(cmd) {
  const fd = popen(cmd, 'r')
  const result = fd.readAsString()
  fd.close()
  return result.trim()
}
