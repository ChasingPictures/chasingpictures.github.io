---
---
maxBy = (array, key) ->
    if (not key?)
        return Math.max(null, array)
    else
        return array.reduce((last, current) ->
            if (not last? || key(current) > key(last))
                return current
            else
                return last
        , null)

Array::maxBy = maxBy

latest = (releases) -> maxBy releases, (rel) -> Date.parse rel.publishedAt

androidApps = (release) ->
    release.assets.filter (asset, index, array) ->
        asset.contentType == "application/vnd.android.package-archive"

size = (asset) ->
    Math.round(100 * asset.size / Math.pow(1024, 2)) / 100


insertLatestDownloadLink = (releases, title, container) ->
    release = latest releases
    app = androidApps(release)[0]
    sizeMB = size app
    version = release.tagName

    a = document.createElement('a');
    a.href = app.browserDownload.url;
    a.innerHTML = 'Download ' + title + ' (' + version + ') (' + sizeMB + ' MB)';
    container.appendChild a

downloadLink = (containerId) ->
    octo = new Octokat()
    repo = octo.repos('{{ site.github_username }}', '{{ site.github.main_repo }}')
    repo.releases.fetch().then (releases) ->
        insertLatestDownloadLink(releases, 'Chasing Pictures', document.getElementById containerId)

window.downloadLink = downloadLink
