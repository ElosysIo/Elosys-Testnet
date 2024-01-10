/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

/* eslint-disable no-console */
import { Platform } from '@elosys/sdk'
import { Hook } from '@oclif/core'
import { ElosysCliPKG } from '../package'

// eslint-disable-next-line @typescript-eslint/require-await
const VersionHook: Hook<'init'> = async () => {
  const isVersionCmd = process.argv[2] === 'version'
  const hasDashVersion = process.argv.some((a) => a === '--version')
  const showVersion = isVersionCmd || hasDashVersion

  if (showVersion) {
    const runtime = Platform.getRuntime()

    console.log(`name       ${ElosysCliPKG.name}`)
    console.log(`version    ${ElosysCliPKG.version}`)
    console.log(`git        ${ElosysCliPKG.git}`)
    console.log(`runtime    ${runtime.type}/${runtime.runtime}`)

    return process.exit(0)
  }
}

export default VersionHook
