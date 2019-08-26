import { popen } from 'std'

export function shell(cmd) {
  const fd = popen(cmd, 'r')
  const result = fd.readAsString()
  fd.close()
  return result
}
