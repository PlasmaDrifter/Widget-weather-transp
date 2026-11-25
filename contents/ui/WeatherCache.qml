/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick
import QtQuick.LocalStorage

Item {
    id: weatherCache

    property var cacheId

    function openDb() {
        return LocalStorage.openDatabaseSync("weather_transp_cache", "1.0", "Weather Widget Cache", 2000000)
    }

    function writeCache(cacheContent) {
        dbgprint('writing cache')
        try {
            var db = openDb()
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS cache(id TEXT PRIMARY KEY, content TEXT)')
                tx.executeSql('INSERT OR REPLACE INTO cache(id, content) VALUES (?, ?)', [String(cacheId || 'default'), String(cacheContent || '{}')])
            })
        } catch (e) {
            dbgprint('writeCache failed: ' + e)
        }
    }

    function readCache() {
        dbgprint('reading cache')
        var content = ''
        try {
            var db = openDb()
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS cache(id TEXT PRIMARY KEY, content TEXT)')
                var rs = tx.executeSql('SELECT content FROM cache WHERE id = ?', [String(cacheId || 'default')])
                if (rs.rows.length > 0) {
                    content = rs.rows.item(0).content || ''
                }
            })
        } catch (e) {
            dbgprint('readCache failed: ' + e)
        }
        return content
    }

}
