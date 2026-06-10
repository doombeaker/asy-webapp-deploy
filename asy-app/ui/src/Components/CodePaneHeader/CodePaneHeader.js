import React, { memo, useState, useRef, useCallback } from 'react';
import cssStyle from './CodePaneHeader.module.css';
import KeyBinding from './KeyBinding';
import { connect } from 'react-redux';
import { actionFact } from "../../Store/store";
import { workspaceInspector } from "../../Util/util";

const Containerconstructor = connect((store) => ({ workspaces: store.workspaces, selectedWorkspace: store.selectedWorkspace }),
  {
    corePanesDisplay: actionFact.corePanesDisplay,
    renameWorkspace: actionFact.renameWorkspace,
    saveCode: actionFact.saveCode,
  })

const CodePaneHeader = Containerconstructor((props) => {
  const currentWorkspace = workspaceInspector(props);
  const [editing, setEditing] = useState(false);
  const [editValue, setEditValue] = useState('');
  const inputRef = useRef(null);

  const startEditing = useCallback(() => {
    if (currentWorkspace.id === null) return;
    setEditValue(currentWorkspace.name.current);
    setEditing(true);
    setTimeout(() => {
      if (inputRef.current) {
        inputRef.current.focus();
        inputRef.current.select();
      }
    }, 0);
  }, [currentWorkspace.id, currentWorkspace.name.current]);

  const finishEditing = useCallback(() => {
    setEditing(false);
    const trimmed = editValue.trim();
    if (trimmed && trimmed !== currentWorkspace.name.current) {
      props.renameWorkspace(currentWorkspace.id, currentWorkspace.name.lastAssigned, trimmed);
    }
  }, [editValue, currentWorkspace]);

  const handleKeyDown = useCallback((e) => {
    if (e.key === 'Enter') finishEditing();
    if (e.key === 'Escape') setEditing(false);
  }, [finishEditing]);

  const handleDownload = useCallback(() => {
    const code = currentWorkspace.codeText;
    const filename = (currentWorkspace.name.current || 'workspace') + '.asy';
    const blob = new Blob([code], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
    URL.revokeObjectURL(url);
  }, [currentWorkspace.codeText, currentWorkspace.name.current]);

  return (
    <div className={cssStyle.corePanesHeader}>
      {editing ? (
        <input
          ref={inputRef}
          className={cssStyle.titleInput}
          value={editValue}
          onChange={(e) => setEditValue(e.target.value)}
          onBlur={finishEditing}
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div className={cssStyle.title} onDoubleClick={startEditing}>
          {currentWorkspace.name.current + '.asy'}
          <KeyBinding/>
        </div>
      )}
      <button className={cssStyle.downloadBtn} onClick={handleDownload} title="Download .asy">
        ↓
      </button>
      <div className={(currentWorkspace.corePanesDisplay.codePane && currentWorkspace.corePanesDisplay.outputPane) ? cssStyle.collapseExpand : cssStyle.collapseExpandBack}
        onClick={(event) => {
          const newValue = !currentWorkspace.corePanesDisplay.outputPane;
          if (currentWorkspace.id !== null) {
            props.corePanesDisplay(currentWorkspace.id, { codePane: true, outputPane: newValue });
          }
        }}
      > </div>
    </div>
  )
})

export default memo(CodePaneHeader);
